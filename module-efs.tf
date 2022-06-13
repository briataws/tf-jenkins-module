# EFS

resource "aws_security_group" "efs_service" {
  vpc_id      = data.aws_vpc.selected.id
  name        = "${var.app_name}-efs-service-sg"
  description = "Allow egress efs"

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.ecs_service.id}"]
  }

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = ["${aws_security_group.ecs_service.id}"]
  }

  ingress {
    from_port       = 2999
    to_port         = 2999
    protocol        = "tcp"
    security_groups = ["${aws_security_group.ecs_service.id}"]
  }

  tags = {
    Name        = "${var.app_name}-efs-service-sg"
    Environment = "${var.environment}"
  }
}

resource "aws_efs_file_system" "service-storage" {
  encrypted = true
  tags = {
    Name = "${var.environment}-${var.app_name}"
  }
}

resource "aws_efs_mount_target" "mount" {
  count           = length(data.aws_subnet.private.*.id)
  file_system_id  = aws_efs_file_system.service-storage.id
  subnet_id       = data.aws_subnet.private[count.index].id
  security_groups = ["${aws_security_group.efs_service.id}"]
}

resource "aws_efs_access_point" "service-storage" {
  file_system_id = aws_efs_file_system.service-storage.id
  posix_user {
    uid = "1000"
    gid = "100"
  }
  root_directory {
    creation_info {
      owner_gid = 1000
      owner_uid = 1000
      permissions = 777
    }
    path = "/jenkins_home"
  }
}

#
# Module: fg-hello-world-app
#

# Security Group for ECS
resource "aws_security_group" "ecs_service" {
  vpc_id      = data.aws_vpc.selected.id
  name        = "${var.app_name}-ecs-service-sg"
  description = "Allow egress from container"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = ["${aws_security_group.inbound_sg.id}"]
  }

  tags = {
    Name        = "${var.app_name}-ecs-service-sg"
    Environment = "${var.environment}"
  }
}

# Simply specify the family to find the latest ACTIVE revision in that family
data "aws_ecs_task_definition" "app" {
  task_definition = aws_ecs_task_definition.app.family
  depends_on      = [aws_ecs_task_definition.app]
}

resource "aws_ecs_service" "app" {
  name            = var.app_name
  task_definition = "${aws_ecs_task_definition.app.family}:${max("${aws_ecs_task_definition.app.revision}", "${data.aws_ecs_task_definition.app.revision}")}"
  desired_count   = var.min
  launch_type     = "FARGATE"
  cluster         = data.aws_ecs_cluster.fargate.id

  network_configuration {
    security_groups = ["${aws_security_group.ecs_service.id}"]
    subnets         = flatten([data.aws_subnet.private.*.id])
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.selected.arn
    container_name   = var.app_name
    container_port   = var.app_port
  }

  # https://github.com/hashicorp/terraform/issues/12634
  depends_on = [aws_alb_listener.selected]
}

#
# Module: fg-hello-world-app:data
#

#
# Data Lookups
#

# AWS VPC Data Lookup
data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name}"]
  }
}

# AWS Subnet IDs Data Lookup
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  tags = {
    Network = "${var.instance_network_tag}"
  }
}

data "aws_subnet" "private" {
  count = length(data.aws_subnets.private.ids)
  id    = data.aws_subnets.private.ids[count.index]
}

# AWS Subnet IDs Data Lookup
data "aws_subnets" "alb" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  tags = {
    Network = "${var.alb_network_tag}"
  }
}

data "aws_subnet" "alb" {
  count = length(data.aws_subnets.alb.ids)
  id    = data.aws_subnets.alb.ids[count.index]
}

# ECS execution role Lookup
data "aws_iam_role" "ecs_execution_role" {
  name = "${var.environment}_ecs_task_execution_role"
}

# ECS cluster Lookup
data "aws_ecs_cluster" "fargate" {
  cluster_name = "${var.environment}-ecs-cluster"
}

# Route53 Lookup
# Feature Enhancement Need to Create Public / Private Route53 Module ugh

data "aws_route53_zone" "selected" {
  vpc_id       = data.aws_vpc.selected.id
  name         = var.route53_zone_name
  private_zone = var.route53_private_zone
}

data "aws_availability_zones" "available" {}


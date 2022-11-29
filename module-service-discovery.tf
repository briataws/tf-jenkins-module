resource "aws_service_discovery_private_dns_namespace" "terraform" {
  name        = "terraform.local"
  description = "Terraform Managed DNS Discovery Service"
  vpc         = data.aws_vpc.selected.id
}

resource "aws_service_discovery_service" "terraform" {
  name = "jenkins"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.terraform.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 2
  }
}

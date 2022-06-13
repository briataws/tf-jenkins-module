//
// Module: fg-hello-world-app
//

output "alb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = aws_alb.selected.dns_name
}

output "route_53_dns_name" {
  description = "The DNS name of the Route53 Record."
  value       = aws_route53_record.selected.fqdn
}

output "aws_security_group_ecs_service_name" {
  description = "The Security Group For The ECS Service."
  value       = aws_security_group.ecs_service.name
}

output "aws_security_group_ecs_service_id" {
  description = "The Security Group For The ECS Service."
  value       = aws_security_group.ecs_service.id
}

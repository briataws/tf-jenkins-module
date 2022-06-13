//
// Module: fg-hello-world-app
//
variable "region" {
  description = "The AWS region"
}

variable "environment" {
  description = "The environment"
}

variable "app_name" {
  description = "The environment"
}

variable "vpc_name" {
  description = "The AWS vpc Name"
}

variable "instance_network_tag" {
  description = "instance_network_tag"
}

variable "alb_network_tag" {
  description = "alb_network_tag"
}

variable "alb_internal" {
  default     = true
  description = "Internal ALB true | false"
}

variable "image_url" {
  description = "The environment"
}

variable "min" {
  description = "Minimum Number Of Containers"
}

variable "max" {
  description = "Maximum Number Of Containers"
}

variable "app_port" {
  description = "Port App Listens On"
}

variable "healthy_threshold" {
  default     = "2"
  description = "ALB Target Group Healthy Threshold"
}

variable "unhealthy_threshold" {
  default     = "4"
  description = "ALB Target Group Unhealthy Threshold"
}

variable "timeout" {
  default     = "10"
  description = "ALB Target Group Timeout"
}

variable "interval" {
  default     = "30"
  description = "ALB Target Group Interval"
}

variable "cpu" {
  default     = "256"
  description = "ECS Task CPU"
}

variable "memory" {
  default     = "1024"
  description = "ECS Task Memory"
}

variable "env_vars" {
  type        = list(map(string))
  description = "ENV VARS for Docker"
}

variable "route53_zone_name" {
  description = "Route 53 Zone Name"
}

variable "route53_private_zone" {
  description = "Route 53 Zone Private true | false"
}

variable "user" {
  default     = "root"
  description = "ECS Docker User"
}

variable "container_path" {
  description = "Container Mount Point"
}

variable "health_check_path" {
  default = "/"
  description = "health check path for the ALB"
}

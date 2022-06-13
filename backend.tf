terraform {
  backend "s3" {
    bucket = "terraform-state-169889227629"
    key    = "jenkins/ecs-service"
  }
}

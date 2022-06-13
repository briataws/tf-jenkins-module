#
# Module: fg-hello-world-app:alb
#

resource "aws_appautoscaling_target" "target" {
  service_namespace  = "ecs"
  resource_id        = "service/${data.aws_ecs_cluster.fargate.cluster_name}/${aws_ecs_service.app.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  role_arn           = data.aws_iam_role.ecs_execution_role.arn
  min_capacity       = var.min
  max_capacity       = var.max
}

resource "aws_appautoscaling_policy" "up" {
  name               = "${var.app_name}_scale_up"
  service_namespace  = "ecs"
  resource_id        = "service/${data.aws_ecs_cluster.fargate.cluster_name}/${aws_ecs_service.app.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }

  depends_on = [aws_appautoscaling_target.target]
}

resource "aws_appautoscaling_policy" "down" {
  name               = "${var.app_name}_scale_down"
  service_namespace  = "ecs"
  resource_id        = "service/${data.aws_ecs_cluster.fargate.cluster_name}/${aws_ecs_service.app.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = -1
    }
  }

  depends_on = [aws_appautoscaling_target.target]
}

/* metric used for auto scale */
resource "aws_cloudwatch_metric_alarm" "service_cpu_high" {
  alarm_name          = "${var.app_name}_cpu_utilization_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "10"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "85"

  dimensions = {
    ClusterName = "${data.aws_ecs_cluster.fargate.cluster_name}"
    ServiceName = "${aws_ecs_service.app.name}"
  }

  alarm_actions = ["${aws_appautoscaling_policy.up.arn}"]
  ok_actions    = ["${aws_appautoscaling_policy.down.arn}"]
}

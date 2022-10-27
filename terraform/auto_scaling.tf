resource "aws_appautoscaling_target" "appautoscaling_target" {
  service_namespace  = var.aws_appautoscaling_target.service_namespace
  resource_id        = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.ecs_service.name}"
  scalable_dimension = var.aws_appautoscaling_target.scalable_dimension
  min_capacity       = var.min_capacity
  max_capacity       = var.max_capacity
}

resource "aws_appautoscaling_policy" "up" {
  name               = var.aws_appautoscaling_policy.up.name
  resource_id        = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.ecs_service.name}"
  scalable_dimension = var.aws_appautoscaling_policy.up.scalable_dimension
  service_namespace  = var.aws_appautoscaling_policy.up.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = var.aws_appautoscaling_policy.up.step_scaling_policy_configuration.adjustment_type
    cooldown                = var.aws_appautoscaling_policy.up.step_scaling_policy_configuration.cooldown
    metric_aggregation_type = var.aws_appautoscaling_policy.up.step_scaling_policy_configuration.metric_aggregation_type

    step_adjustment {
      scaling_adjustment          = var.aws_appautoscaling_policy.up.step_scaling_policy_configuration.step_adjustment.scaling_adjustment
      metric_interval_lower_bound = var.aws_appautoscaling_policy.up.step_scaling_policy_configuration.step_adjustment.metric_interval_lower_bound
    }
  }
}

resource "aws_appautoscaling_policy" "down" {
  name               = var.aws_appautoscaling_policy.down.name
  resource_id        = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.ecs_service.name}"
  scalable_dimension = var.aws_appautoscaling_policy.down.scalable_dimension
  service_namespace  = var.aws_appautoscaling_policy.down.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = var.aws_appautoscaling_policy.down.step_scaling_policy_configuration.adjustment_type
    cooldown                = var.aws_appautoscaling_policy.down.step_scaling_policy_configuration.cooldown
    metric_aggregation_type = var.aws_appautoscaling_policy.down.step_scaling_policy_configuration.metric_aggregation_type

    step_adjustment {
      scaling_adjustment          = var.aws_appautoscaling_policy.down.step_scaling_policy_configuration.step_adjustment.scaling_adjustment
      metric_interval_upper_bound = var.aws_appautoscaling_policy.down.step_scaling_policy_configuration.step_adjustment.metric_interval_upper_bound
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "high" {
  alarm_name          = var.aws_cloudwatch_metric_alarm.high.alert_name
  comparison_operator = var.aws_cloudwatch_metric_alarm.high.comparison_operator
  evaluation_periods  = var.aws_cloudwatch_metric_alarm.high.evaluation_periods
  metric_name         = var.aws_cloudwatch_metric_alarm.high.metric_name
  namespace           = var.aws_cloudwatch_metric_alarm.high.namespace
  period              = var.aws_cloudwatch_metric_alarm.high.period
  statistic           = var.aws_cloudwatch_metric_alarm.high.statistic
  threshold           = var.aws_cloudwatch_metric_alarm.high.threshold

  dimensions = {
    ClusterName = aws_ecs_cluster.ecs_cluster.name
    ServiceName = aws_ecs_service.ecs_service.name
  }

  alarm_actions = [aws_appautoscaling_policy.up.arn]
}

resource "aws_cloudwatch_metric_alarm" "low" {
  alarm_name          = var.aws_cloudwatch_metric_alarm.low.alert_name
  comparison_operator = var.aws_cloudwatch_metric_alarm.low.comparison_operator
  evaluation_periods  = var.aws_cloudwatch_metric_alarm.low.evaluation_periods
  metric_name         = var.aws_cloudwatch_metric_alarm.low.metric_name
  namespace           = var.aws_cloudwatch_metric_alarm.low.namespace
  period              = var.aws_cloudwatch_metric_alarm.low.period
  statistic           = var.aws_cloudwatch_metric_alarm.low.statistic
  threshold           = var.aws_cloudwatch_metric_alarm.low.threshold

  dimensions = {
    ClusterName = aws_ecs_cluster.ecs_cluster.name
    ServiceName = aws_ecs_service.ecs_service.name
  }

  alarm_actions = [aws_appautoscaling_policy.down.arn]
}
locals {
  name_prefix = var.environment

  # Module-owned tags are merged last so callers cannot accidentally override them.
  common_tags = merge(var.tags, {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Module      = "monitoring"
    Project     = "multi-environment-aws-infrastructure"
  })
}

# -----------------------------------------------------------------------------
# SNS topic: the "mailbox" that alarms send their messages to.
# -----------------------------------------------------------------------------
resource "aws_sns_topic" "alerts" {
  name = "${local.name_prefix}-alerts"

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-alerts"
  })
}

# Email subscription: created only when alert_email is set.
# AWS sends a confirmation email first; alerts arrive only after you click
# "Confirm subscription" in that email.
resource "aws_sns_topic_subscription" "email" {
  count = var.alert_email == null ? 0 : 1

  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# -----------------------------------------------------------------------------
# CPU alarms: average CPU above the threshold for 2 periods of 5 minutes.
# EC2 sends CPU metrics every 5 minutes for free (basic monitoring).
# -----------------------------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "frontend_cpu_high" {
  alarm_name          = "${local.name_prefix}-frontend-cpu-high"
  alarm_description   = "Frontend CPU above ${var.cpu_threshold_percent}% for 10 minutes."
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  dimensions          = { InstanceId = var.frontend_instance_id }
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 2
  threshold           = var.cpu_threshold_percent
  comparison_operator = "GreaterThanThreshold"
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-frontend-cpu-high"
    Tier = "public"
  })
}

resource "aws_cloudwatch_metric_alarm" "backend_cpu_high" {
  alarm_name          = "${local.name_prefix}-backend-cpu-high"
  alarm_description   = "Backend CPU above ${var.cpu_threshold_percent}% for 10 minutes."
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  dimensions          = { InstanceId = var.backend_instance_id }
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 2
  threshold           = var.cpu_threshold_percent
  comparison_operator = "GreaterThanThreshold"
  treat_missing_data  = "notBreaching"
}


# -----------------------------------------------------------------------------
# Status-check alarms: AWS checks every minute that the instance and the
# hardware it runs on are healthy. Fires after 2 failed checks in a row.
# -----------------------------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "frontend_status_check" {
  alarm_name          = "${local.name_prefix}-frontend-status-check-failed"
  alarm_description   = "Frontend instance or its host failed AWS status checks."
  namespace           = "AWS/EC2"
  metric_name         = "StatusCheckFailed"
  dimensions          = { InstanceId = var.frontend_instance_id }
  statistic           = "Maximum"
  period              = 60
  evaluation_periods  = 2
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-frontend-status-check-failed"
    Tier = "public"
  })
}

resource "aws_cloudwatch_metric_alarm" "backend_status_check" {
  alarm_name          = "${local.name_prefix}-backend-status-check-failed"
  alarm_description   = "Backend instance or its host failed AWS status checks."
  namespace           = "AWS/EC2"
  metric_name         = "StatusCheckFailed"
  dimensions          = { InstanceId = var.backend_instance_id }
  statistic           = "Maximum"
  period              = 60
  evaluation_periods  = 2
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-backend-status-check-failed"
    Tier = "private"
  })
}
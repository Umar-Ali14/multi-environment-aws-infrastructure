output "alerts_topic_arn" {
  description = "ARN of the SNS topic that receives alarm notifications."
  value       = aws_sns_topic.alerts.arn
}

output "alarm_names" {
  description = "Names of the CloudWatch alarms created for this environment."
  value = [
    aws_cloudwatch_metric_alarm.frontend_cpu_high.alarm_name,
    aws_cloudwatch_metric_alarm.backend_cpu_high.alarm_name,
    aws_cloudwatch_metric_alarm.frontend_status_check.alarm_name,
    aws_cloudwatch_metric_alarm.backend_status_check.alarm_name,
  ]
}
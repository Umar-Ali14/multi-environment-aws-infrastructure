# -----------------------------------------------------------------------------
# Network
# -----------------------------------------------------------------------------
output "vpc_id" {
  description = "ID of the prod VPC."
  value       = module.network.vpc_id
}

output "public_subnet_id" {
  description = "ID of the prod public subnet."
  value       = module.network.public_subnet_id
}

output "private_subnet_id" {
  description = "ID of the prod private subnet."
  value       = module.network.private_subnet_id
}

# -----------------------------------------------------------------------------
# Security
# -----------------------------------------------------------------------------
output "frontend_security_group_id" {
  description = "ID of the prod frontend Security Group."
  value       = module.security.frontend_security_group_id
}

output "backend_security_group_id" {
  description = "ID of the prod backend Security Group."
  value       = module.security.backend_security_group_id
}

# -----------------------------------------------------------------------------
# Compute
# -----------------------------------------------------------------------------
output "frontend_instance_id" {
  description = "ID of the prod frontend EC2 instance."
  value       = module.compute.frontend_instance_id
}

output "frontend_public_ip" {
  description = "Public IP of the prod frontend. Open http://<this IP> in a browser once a web server runs on it."
  value       = module.compute.frontend_public_ip
}

output "backend_instance_id" {
  description = "ID of the prod backend EC2 instance."
  value       = module.compute.backend_instance_id
}

output "backend_private_ip" {
  description = "Private IP of the prod backend. Only reachable from the frontend, on the app port."
  value       = module.compute.backend_private_ip
}

# -----------------------------------------------------------------------------
# Monitoring
# -----------------------------------------------------------------------------
output "alerts_topic_arn" {
  description = "ARN of the SNS topic that receives alarm notifications."
  value       = module.monitoring.alerts_topic_arn
}

output "alarm_names" {
  description = "Names of the CloudWatch alarms for this environment."
  value       = module.monitoring.alarm_names
}
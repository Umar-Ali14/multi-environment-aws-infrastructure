# -----------------------------------------------------------------------------
# Network
# -----------------------------------------------------------------------------
output "vpc_id" {
  description = "ID of the staging VPC."
  value       = module.network.vpc_id
}

output "public_subnet_id" {
  description = "ID of the staging public subnet."
  value       = module.network.public_subnet_id
}

output "private_subnet_id" {
  description = "ID of the staging private subnet."
  value       = module.network.private_subnet_id
}

# -----------------------------------------------------------------------------
# Security
# -----------------------------------------------------------------------------
output "frontend_security_group_id" {
  description = "ID of the staging frontend Security Group."
  value       = module.security.frontend_security_group_id
}

output "backend_security_group_id" {
  description = "ID of the staging backend Security Group."
  value       = module.security.backend_security_group_id
}

# -----------------------------------------------------------------------------
# Compute
# -----------------------------------------------------------------------------
output "frontend_instance_id" {
  description = "ID of the staging frontend EC2 instance."
  value       = module.compute.frontend_instance_id
}

output "frontend_public_ip" {
  description = "Public IP of the staging frontend. Open http://<this IP> in a browser once a web server runs on it."
  value       = module.compute.frontend_public_ip
}

output "backend_instance_id" {
  description = "ID of the staging backend EC2 instance."
  value       = module.compute.backend_instance_id
}

output "backend_private_ip" {
  description = "Private IP of the staging backend. Only reachable from the frontend, on the app port."
  value       = module.compute.backend_private_ip
}
output "frontend_security_group_id" {
  description = "ID of the frontend Security Group. Attach it to the frontend EC2 instance."
  value       = aws_security_group.frontend.id
}

output "backend_security_group_id" {
  description = "ID of the backend Security Group. Attach it to the backend EC2 instance."
  value       = aws_security_group.backend.id
}
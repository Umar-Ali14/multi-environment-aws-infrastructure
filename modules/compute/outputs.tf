output "frontend_instance_id" {
  description = "ID of the frontend EC2 instance."
  value       = aws_instance.frontend.id
}

output "frontend_public_ip" {
  description = "Public IPv4 address of the frontend instance. Changes if the instance is stopped and started."
  value       = aws_instance.frontend.public_ip
}

output "frontend_private_ip" {
  description = "Private IPv4 address of the frontend instance."
  value       = aws_instance.frontend.private_ip
}

output "backend_instance_id" {
  description = "ID of the backend EC2 instance."
  value       = aws_instance.backend.id
}

output "backend_private_ip" {
  description = "Private IPv4 address of the backend instance. The frontend uses this to reach the backend on the app port."
  value       = aws_instance.backend.private_ip
}

output "ami_id" {
  description = "Amazon Linux 2023 AMI ID resolved at plan time (instances keep their original AMI because of ignore_changes)."
  value       = data.aws_ssm_parameter.al2023_ami.insecure_value
}
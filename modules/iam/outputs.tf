output "ec2_role_name" {
  description = "Name of the IAM role used by the EC2 instances."
  value       = aws_iam_role.ec2.name
}

output "ec2_role_arn" {
  description = "ARN of the IAM role used by the EC2 instances."
  value       = aws_iam_role.ec2.arn
}

output "ec2_instance_profile_name" {
  description = "Name of the instance profile. Pass it to the compute module's iam_instance_profile_name."
  value       = aws_iam_instance_profile.ec2.name
}
# Template for environments/prod/terraform.tfvars.
# Copy this file to terraform.tfvars and adjust the values.
# This file is committed to Git; terraform.tfvars is not.

environment = "prod"
aws_region  = "us-east-1"

# Network (must not overlap with dev 10.0.0.0/16 or staging 10.1.0.0/16)
vpc_cidr            = "10.2.0.0/16"
public_subnet_cidr  = "10.2.1.0/24"
private_subnet_cidr = "10.2.2.0/24"
availability_zone   = "us-east-1a"

# Security
app_port = 8080

# Compute (one size up from dev/staging; change to t3.micro to save cost while learning)
frontend_instance_type = "t3.small"
backend_instance_type  = "t3.small"

# Extra tags
tags = {
  Owner = "your-name"
}

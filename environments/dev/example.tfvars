# Template for environments/dev/terraform.tfvars.
# Copy this file to terraform.tfvars and adjust the values.
# This file is committed to Git; terraform.tfvars is not.

environment = "dev"
aws_region  = "us-east-1"

# Network (must not overlap with staging or prod)
vpc_cidr            = "10.0.0.0/16"
public_subnet_cidr  = "10.0.1.0/24"
private_subnet_cidr = "10.0.2.0/24"
availability_zone   = "us-east-1a"

# Security
app_port = 8080

# Compute
frontend_instance_type = "t3.micro"
backend_instance_type  = "t3.micro"

# Extra tags
tags = {
  Owner = "your-name"
}

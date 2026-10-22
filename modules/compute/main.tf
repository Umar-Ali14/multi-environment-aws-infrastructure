locals {
  name_prefix = var.environment

  # Module-owned tags are merged last so callers cannot accidentally override them.
  common_tags = merge(var.tags, {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Module      = "compute"
    Project     = "multi-environment-aws-infrastructure"
  })
}

# Latest Amazon Linux 2023 AMI (x86_64), published by AWS in SSM Parameter Store.
# This always resolves to the current AMI ID for the provider's region.
# insecure_value is used because a public AMI ID is not secret; "value" would
# hide the AMI ID as "(sensitive value)" in every plan.
data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# Frontend instance (public subnet)
resource "aws_instance" "frontend" {
  ami                         = data.aws_ssm_parameter.al2023_ami.insecure_value
  instance_type               = var.frontend_instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.frontend_security_group_id]
  associate_public_ip_address = true
  iam_instance_profile        = var.iam_instance_profile_name

  # Require IMDSv2 (session tokens) for the instance metadata service.
  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = var.root_volume_size
    encrypted   = true

    tags = merge(local.common_tags, {
      Name = "${local.name_prefix}-frontend-root"
      Tier = "public"
    })
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-frontend"
    Tier = "public"
    Role = "frontend"
  })

  # A new AMI is published regularly. Ignore AMI changes so a routine
  # `terraform plan` does not replace (destroy and recreate) the instance.
  lifecycle {
    ignore_changes = [ami]
  }
}

# Backend instance (private subnet, no public IP)
resource "aws_instance" "backend" {
  ami                         = data.aws_ssm_parameter.al2023_ami.insecure_value
  instance_type               = var.backend_instance_type
  subnet_id                   = var.private_subnet_id
  vpc_security_group_ids      = [var.backend_security_group_id]
  associate_public_ip_address = false
  iam_instance_profile        = var.iam_instance_profile_name

  # Require IMDSv2 (session tokens) for the instance metadata service.
  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = var.root_volume_size
    encrypted   = true

    tags = merge(local.common_tags, {
      Name = "${local.name_prefix}-backend-root"
      Tier = "private"
    })
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-backend"
    Tier = "private"
    Role = "backend"
  })

  # A new AMI is published regularly. Ignore AMI changes so a routine
  # `terraform plan` does not replace (destroy and recreate) the instance.
  lifecycle {
    ignore_changes = [ami]
  }
}
locals {
  name_prefix = var.environment

  # Module-owned tags are merged last so callers cannot accidentally override them.
  common_tags = merge(var.tags, {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Module      = "iam"
    Project     = "multi-environment-aws-infrastructure"
  })
}

# Trust policy: who is allowed to use (assume) this role.
# Only the EC2 service may assume it, on behalf of our instances.
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# IAM role for the EC2 instances.
# Gives the instances temporary AWS credentials, so no access keys are ever
# stored on a server.
resource "aws_iam_role" "ec2" {
  name               = "${local.name_prefix}-ec2-role"
  description        = "Role for ${var.environment} EC2 instances (SSM Session Manager)"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-ec2-role"
  })
}

# Permissions: AWS managed policy for Systems Manager.
# Lets the SSM Agent (pre-installed on Amazon Linux 2023) register the instance
# and accept Session Manager connections. No SSH or open port needed.
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Instance profile: the "container" EC2 uses to receive the role.
# An EC2 instance cannot take a role directly, only an instance profile.
resource "aws_iam_instance_profile" "ec2" {
  name = "${local.name_prefix}-ec2-instance-profile"
  role = aws_iam_role.ec2.name

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-ec2-instance-profile"
  })
}
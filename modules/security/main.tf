locals {
  name_prefix = var.environment

  # Module-owned tags are merged last so callers cannot accidentally override them.
  common_tags = merge(var.tags, {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Module      = "security"
    Project     = "multi-environment-aws-infrastructure"
  })
}

# Rules are defined as separate aws_vpc_security_group_*_rule resources
# (current AWS provider practice), so the groups below contain no inline rules.
# No SSH rule exists in either group. Use AWS Systems Manager Session Manager
# for shell access instead of opening port 22.

# Frontend Security Group (public subnet)
resource "aws_security_group" "frontend" {
  name        = "${local.name_prefix}-frontend-sg"
  description = "Frontend web servers: HTTP and HTTPS inbound"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-frontend-sg"
    Tier = "public"
  })
}

resource "aws_vpc_security_group_ingress_rule" "frontend_http" {
  security_group_id = aws_security_group.frontend.id
  description       = "HTTP from allowed clients"
  cidr_ipv4         = var.frontend_ingress_cidr
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "frontend_https" {
  security_group_id = aws_security_group.frontend.id
  description       = "HTTPS from allowed clients"
  cidr_ipv4         = var.frontend_ingress_cidr
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

# Outbound: the frontend needs the internet (OS updates, packages) and the backend.
resource "aws_vpc_security_group_egress_rule" "frontend_all" {
  security_group_id = aws_security_group.frontend.id
  description       = "All outbound traffic"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # all protocols and ports
}

# Backend Security Group (private subnet)
resource "aws_security_group" "backend" {
  name        = "${local.name_prefix}-backend-sg"
  description = "Backend application servers: app port from frontend only"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-backend-sg"
    Tier = "private"
  })
}

resource "aws_vpc_security_group_ingress_rule" "backend_app_from_frontend" {
  security_group_id            = aws_security_group.backend.id
  description                  = "Application traffic from the frontend Security Group"
  referenced_security_group_id = aws_security_group.frontend.id
  ip_protocol                  = "tcp"
  from_port                    = var.app_port
  to_port                      = var.app_port
}

# Outbound: limited to the VPC. The private subnet has no route to the internet
# anyway, so this loses nothing today and keeps the rule honest.
resource "aws_vpc_security_group_egress_rule" "backend_vpc_only" {
  security_group_id = aws_security_group.backend.id
  description       = "Outbound traffic inside the VPC only"
  cidr_ipv4         = var.vpc_cidr_block
  ip_protocol       = "-1" # all protocols and ports
}
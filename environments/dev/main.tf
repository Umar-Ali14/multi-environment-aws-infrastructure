# -----------------------------------------------------------------------------
# Dev environment: settings
# All dev-specific values live here, so the modules stay reusable.
# -----------------------------------------------------------------------------
locals {
  environment = "dev"
  aws_region  = "us-east-1"

  # Network (must not overlap with staging or prod if they are ever peered)
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
  availability_zone   = "us-east-1a" # both subnets in one AZ: cheaper, less resilient

  # Security
  app_port = 8080

  # Compute (smallest sensible size for dev)
  frontend_instance_type = "t3.micro"
  backend_instance_type  = "t3.micro"

  # Extra tags added to every resource (modules add Environment, Project, etc.)
  tags = {
    Owner = "CloudOps Team"
  }
}

# -----------------------------------------------------------------------------
# AWS provider
# Credentials come from your AWS CLI profile or environment, never from code.
# -----------------------------------------------------------------------------
provider "aws" {
  region = local.aws_region
}

# -----------------------------------------------------------------------------
# Network: VPC, subnets, Internet Gateway, route tables
# -----------------------------------------------------------------------------
module "network" {
  source = "../../modules/network"

  environment         = local.environment
  vpc_cidr            = local.vpc_cidr
  public_subnet_cidr  = local.public_subnet_cidr
  private_subnet_cidr = local.private_subnet_cidr
  public_subnet_az    = local.availability_zone
  private_subnet_az   = local.availability_zone
  tags                = local.tags
}

# -----------------------------------------------------------------------------
# Security: frontend and backend Security Groups
# -----------------------------------------------------------------------------
module "security" {
  source = "../../modules/security"

  environment    = local.environment
  vpc_id         = module.network.vpc_id
  vpc_cidr_block = module.network.vpc_cidr_block
  app_port       = local.app_port
  tags           = local.tags
}

# -----------------------------------------------------------------------------
# Compute: frontend EC2 (public subnet) and backend EC2 (private subnet)
# -----------------------------------------------------------------------------
module "compute" {
  source = "../../modules/compute"

  environment                = local.environment
  public_subnet_id           = module.network.public_subnet_id
  private_subnet_id          = module.network.private_subnet_id
  frontend_security_group_id = module.security.frontend_security_group_id
  backend_security_group_id  = module.security.backend_security_group_id
  frontend_instance_type     = local.frontend_instance_type
  backend_instance_type      = local.backend_instance_type
  tags                       = local.tags
}
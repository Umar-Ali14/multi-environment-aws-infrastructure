# -----------------------------------------------------------------------------
# Staging environment
# Values come from terraform.tfvars (see example.tfvars for a template),
# so the modules stay reusable.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# AWS provider
# Credentials come from your AWS CLI profile or environment, never from code.
# -----------------------------------------------------------------------------
provider "aws" {
  region = var.aws_region
}

# -----------------------------------------------------------------------------
# Network: VPC, subnets, Internet Gateway, route tables
# -----------------------------------------------------------------------------
module "network" {
  source = "../../modules/network"

  environment         = var.environment
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  public_subnet_az    = var.availability_zone
  private_subnet_az   = var.availability_zone
  tags                = var.tags
}

# -----------------------------------------------------------------------------
# Security: frontend and backend Security Groups
# -----------------------------------------------------------------------------
module "security" {
  source = "../../modules/security"

  environment    = var.environment
  vpc_id         = module.network.vpc_id
  vpc_cidr_block = module.network.vpc_cidr_block
  app_port       = var.app_port
  tags           = var.tags
}

# -----------------------------------------------------------------------------
# Compute: frontend EC2 (public subnet) and backend EC2 (private subnet)
# -----------------------------------------------------------------------------
module "compute" {
  source = "../../modules/compute"

  environment                = var.environment
  public_subnet_id           = module.network.public_subnet_id
  private_subnet_id          = module.network.private_subnet_id
  frontend_security_group_id = module.security.frontend_security_group_id
  backend_security_group_id  = module.security.backend_security_group_id
  frontend_instance_type     = var.frontend_instance_type
  backend_instance_type      = var.backend_instance_type
  tags                       = var.tags
}

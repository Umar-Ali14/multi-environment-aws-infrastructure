variable "environment" {
  description = "Environment name (e.g. dev, staging, prod). Used in resource names and the Environment tag."
  type        = string
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block for the VPC (e.g. 10.0.0.0/16). Must not overlap with other environments if they will ever be peered."
  type        = string
}

variable "public_subnet_cidr" {
  description = "IPv4 CIDR block for the public subnet. Must sit inside vpc_cidr."
  type        = string
}

variable "private_subnet_cidr" {
  description = "IPv4 CIDR block for the private subnet. Must sit inside vpc_cidr and must not overlap the public subnet."
  type        = string
}

variable "public_subnet_az" {
  description = "Availability Zone for the public subnet (e.g. us-east-1a). Must belong to the provider's region."
  type        = string
}

variable "private_subnet_az" {
  description = "Availability Zone for the private subnet (e.g. us-east-1a). Must belong to the provider's region."
  type        = string
}

variable "tags" {
  description = "Additional tags merged into every resource in this module (e.g. Project, Owner, CostCenter)."
  type        = map(string)
  default     = {}
}
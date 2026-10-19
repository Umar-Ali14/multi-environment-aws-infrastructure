variable "environment" {
  description = "Environment name (e.g. dev, staging, prod). Used in resource names and the Environment tag."
  type        = string
}

variable "public_subnet_id" {
  description = "ID of the public subnet for the frontend instance. Pass module.network.public_subnet_id."
  type        = string
}

variable "private_subnet_id" {
  description = "ID of the private subnet for the backend instance. Pass module.network.private_subnet_id."
  type        = string
}

variable "frontend_security_group_id" {
  description = "ID of the frontend Security Group. Pass module.security.frontend_security_group_id."
  type        = string
}

variable "backend_security_group_id" {
  description = "ID of the backend Security Group. Pass module.security.backend_security_group_id."
  type        = string
}

variable "frontend_instance_type" {
  description = "EC2 instance type for the frontend (e.g. t3.micro for dev, t3.small for prod). Must be an x86_64 type to match the AMI."
  type        = string
  default     = "t3.micro"
}

variable "backend_instance_type" {
  description = "EC2 instance type for the backend (e.g. t3.micro for dev, t3.small for prod). Must be an x86_64 type to match the AMI."
  type        = string
  default     = "t3.micro"
}

variable "root_volume_size" {
  description = "Size of each instance's root EBS volume in GiB. Amazon Linux 2023 needs at least 8."
  type        = number
  default     = 8
}

variable "iam_instance_profile_name" {
  description = "Name of an existing IAM instance profile to attach to both instances (e.g. one allowing SSM Session Manager). Leave null for none."
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional tags merged into every resource in this module (e.g. Owner, CostCenter)."
  type        = map(string)
  default     = {}
}
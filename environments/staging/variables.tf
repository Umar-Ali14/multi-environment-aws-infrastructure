variable "environment" {
  description = "Environment name. Used in resource names and the Environment tag."
  type        = string
}

variable "aws_region" {
  description = "AWS region to deploy into (e.g. us-east-1)."
  type        = string
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block for the VPC. Must not overlap with staging or prod."
  type        = string
}

variable "public_subnet_cidr" {
  description = "IPv4 CIDR block for the public subnet. Must sit inside vpc_cidr."
  type        = string
}

variable "private_subnet_cidr" {
  description = "IPv4 CIDR block for the private subnet. Must sit inside vpc_cidr."
  type        = string
}

variable "availability_zone" {
  description = "Availability Zone for both subnets (e.g. us-east-1a). Must belong to aws_region."
  type        = string
}

variable "app_port" {
  description = "TCP port the backend application listens on."
  type        = number
}

variable "frontend_instance_type" {
  description = "EC2 instance type for the frontend (x86_64, e.g. t3.micro)."
  type        = string
}

variable "backend_instance_type" {
  description = "EC2 instance type for the backend (x86_64, e.g. t3.micro)."
  type        = string
}

variable "tags" {
  description = "Extra tags added to every resource (modules add Environment, Project, etc.)."
  type        = map(string)
  default     = {}
}

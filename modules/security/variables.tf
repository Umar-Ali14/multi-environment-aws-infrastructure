variable "environment" {
  description = "Environment name (e.g. dev, staging, prod). Used in resource names and the Environment tag."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the Security Groups are created. Pass module.network.vpc_id."
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block of the VPC. The backend may only send outbound traffic inside this range. Pass module.network.vpc_cidr_block."
  type        = string
}

variable "app_port" {
  description = "TCP port the backend application listens on. Only the frontend Security Group may reach it."
  type        = number
  default     = 8080
}

variable "frontend_ingress_cidr" {
  description = "IPv4 CIDR allowed to reach the frontend on HTTP (80) and HTTPS (443). Use 0.0.0.0/0 for a public website, or your own IP (x.x.x.x/32) to restrict a dev environment."
  type        = string
  default     = "0.0.0.0/0"
}

variable "tags" {
  description = "Additional tags merged into every resource in this module (e.g. Owner, CostCenter)."
  type        = map(string)
  default     = {}
}
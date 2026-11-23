variable "environment" {
  description = "Environment name (e.g. dev, staging, prod). Used in resource names and the Environment tag."
  type        = string
}

variable "tags" {
  description = "Additional tags merged into every resource in this module (e.g. Owner, CostCenter)."
  type        = map(string)
  default     = {}
}
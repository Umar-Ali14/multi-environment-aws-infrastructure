variable "environment" {
  description = "Environment name (e.g. dev, staging, prod). Used in resource names and the Environment tag."
  type        = string
}

variable "frontend_instance_id" {
  description = "ID of the frontend EC2 instance to monitor. Pass module.compute.frontend_instance_id."
  type        = string
}

variable "backend_instance_id" {
  description = "ID of the backend EC2 instance to monitor. Pass module.compute.backend_instance_id."
  type        = string
}

variable "cpu_threshold_percent" {
  description = "CPU usage (%) that triggers the CPU alarm when exceeded for 10 minutes."
  type        = number
  default     = 80
}

variable "alert_email" {
  description = "Email address that receives alarm notifications. Leave null to create the alarms without email."
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional tags merged into every resource in this module (e.g. Owner, CostCenter)."
  type        = map(string)
  default     = {}
}
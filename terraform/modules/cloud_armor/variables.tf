variable "enable" {
  type        = bool
  description = "Whether to enable Cloud Armor"
  default     = false
}

variable "project_id" {
  type        = string
  description = "The GCP project ID"
}

variable "project_prefix" {
  type        = string
  description = "Project prefix for resource naming"
  default     = "mortru"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g., dev, staging, prod)"
}

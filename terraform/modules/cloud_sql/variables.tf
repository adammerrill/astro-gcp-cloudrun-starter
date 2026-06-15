variable "enable" {
  type        = bool
  description = "Whether to enable Cloud SQL"
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

variable "region" {
  type        = string
  description = "The GCP region"
  default     = "us-central1"
}

variable "vpc_network_id" {
  type        = string
  description = "The VPC network self link for private IP connectivity"
  default     = ""
}

variable "tier" {
  type        = string
  description = "The machine type tier for the database instance"
  default     = "db-f1-micro"
}

variable "deletion_protection" {
  type        = bool
  description = "Whether deletion protection is enabled on the database"
  default     = false
}

variable "pitr_enabled" {
  type        = bool
  description = "Whether Point-In-Time Recovery (PITR) is enabled"
  default     = false
}

variable "db_name" {
  type        = string
  description = "Database name to create"
  default     = "astrowind"
}

variable "db_user" {
  type        = string
  description = "Database admin username"
  default     = "dbadmin"
}

variable "db_password" {
  type        = string
  description = "Database admin password"
  default     = "temporary_password_change_me"
}

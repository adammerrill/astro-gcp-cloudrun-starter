variable "create_project" {
  type        = bool
  description = "Whether to create the GCP project"
  default     = true
}

variable "project_name" {
  type        = string
  description = "Display name for the dev project"
  default     = "Mortru Dev"
}

variable "project_id" {
  type        = string
  description = "GCP project ID for the dev project"
  default     = "mortru-dev"
}

variable "billing_account_id" {
  type        = string
  description = "Billing account ID to associate with the project"
}

variable "org_id" {
  type        = string
  description = "Organization ID (leave empty if not using)"
  default     = ""
}

variable "folder_id" {
  type        = string
  description = "Folder ID to place the project in (leave empty if not using)"
  default     = ""
}

variable "deletion_policy" {
  type        = string
  description = "Project deletion policy (DELETE, PREVENT, ABANDON)"
  default     = "DELETE"
}

variable "project_prefix" {
  type        = string
  description = "Project prefix for resource naming"
  default     = "mortru"
}

variable "region" {
  type        = string
  description = "Primary region for resources"
  default     = "us-central1"
}

variable "dr_region" {
  type        = string
  description = "Secondary DR region"
  default     = "us-east1"
}

variable "environment" {
  type        = string
  description = "Deployment environment"
  default     = "dev"
}

variable "shared_project_id" {
  type        = string
  description = "Shared infrastructure project ID"
  default     = "mortru-shared"
}

variable "audit_log_retention_days" {
  type        = number
  description = "Audit log retention period in days"
  default     = 30
}

variable "secrets" {
  type        = map(any)
  description = "Secrets metadata to define"
  default     = {}
}

variable "service_name" {
  type        = string
  description = "Cloud Run service name"
  default     = "astrowind"
}

variable "image" {
  type        = string
  description = "Container image URI"
  default     = "us-docker.pkg.dev/cloudrun/container/hello"
}

variable "cloud_run_min_instances" {
  type        = number
  description = "Minimum instance count for scaling"
  default     = 0
}

variable "cloud_run_max_instances" {
  type        = number
  description = "Maximum instance count for scaling"
  default     = 2
}

variable "cloud_run_cpu_limit" {
  type        = string
  description = "CPU limits per instance"
  default     = "0.5"
}

variable "cloud_run_memory_limit" {
  type        = string
  description = "Memory limits per instance"
  default     = "256Mi"
}

variable "cloud_run_startup_cpu_boost" {
  type        = bool
  description = "Enable CPU boost at startup"
  default     = true
}

variable "cloud_run_deletion_protection" {
  type        = bool
  description = "Prevent Cloud Run deletion via Terraform"
  default     = false
}

variable "cloud_run_ingress" {
  type        = string
  description = "Ingress settings"
  default     = "INGRESS_TRAFFIC_ALL"
}

variable "cloud_run_allow_unauthenticated" {
  type        = bool
  description = "Allow public access to Cloud Run"
  default     = true
}

variable "cloud_run_secret_env_vars" {
  type        = list(any)
  description = "Environment variables sourced from secrets"
  default     = []
}

variable "cloud_run_env_vars" {
  type        = list(any)
  description = "Plain text environment variables"
  default     = []
}

variable "uptime_check_host" {
  type        = string
  description = "Custom host to check for uptime (defaults to service URL)"
  default     = ""
}

variable "notification_channels" {
  type        = list(string)
  description = "Notification channels for alerting"
  default     = []
}

variable "monthly_budget_usd" {
  type        = number
  description = "Monthly budget limit in USD"
  default     = 5
}

# --- Feature-Gated Modules ---

variable "enable_networking" {
  type        = bool
  description = "Enable networking resources (VPC, etc.)"
  default     = false
}

variable "subnet_cidr" {
  type        = string
  description = "VPC Subnet CIDR"
  default     = "10.0.1.0/24"
}

variable "enable_dns" {
  type        = bool
  description = "Enable DNS resources"
  default     = false
}

variable "domain" {
  type        = string
  description = "Custom domain name"
  default     = "example.com"
}

variable "enable_cloud_armor" {
  type        = bool
  description = "Enable Cloud Armor security policy"
  default     = false
}

variable "enable_load_balancer" {
  type        = bool
  description = "Enable Global Load Balancer"
  default     = false
}

variable "enable_cloud_sql" {
  type        = bool
  description = "Enable Cloud SQL"
  default     = false
}

variable "db_tier" {
  type        = string
  description = "Database machine tier"
  default     = "db-f1-micro"
}

variable "db_deletion_protection" {
  type        = bool
  description = "Enable database deletion protection"
  default     = false
}

variable "db_pitr_enabled" {
  type        = bool
  description = "Enable database PITR backups"
  default     = false
}

variable "db_name" {
  type        = string
  description = "Database name"
  default     = "astrowind"
}

variable "db_user" {
  type        = string
  description = "Database admin user"
  default     = "dbadmin"
}

variable "db_password" {
  type        = string
  description = "Database admin password"
  default     = "temporary_password_change_me"
}

variable "enable_vertex_ai" {
  type        = bool
  description = "Enable Vertex AI resources"
  default     = false
}

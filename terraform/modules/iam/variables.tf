variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, production)"
  type        = string
}

variable "shared_project_id" {
  description = "Shared project ID for cross-project IAM (AR read access)"
  type        = string
  default     = ""
}

variable "create_wif" {
  description = "Create Workload Identity Federation resources (shared project only)"
  type        = bool
  default     = false
}

variable "github_owner" {
  description = "GitHub repository owner for WIF attribute condition"
  type        = string
  default     = "adammerrill"
}

variable "enable_cloud_sql" {
  description = "Create Cloud SQL service account"
  type        = bool
  default     = false
}

variable "enable_vertex_ai" {
  description = "Create Vertex AI service account"
  type        = bool
  default     = false
}

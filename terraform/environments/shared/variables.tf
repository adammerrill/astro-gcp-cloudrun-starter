variable "create_project" {
  type        = bool
  description = "Whether Terraform should create the GCP project. The bootstrap module already creates all projects, so environment layers default to false and adopt the existing project."
  default     = false
}

variable "project_name" {
  type        = string
  description = "Display name for the shared project"
  default     = "Mortru Shared"
}

variable "project_id" {
  type        = string
  description = "GCP project ID for the shared project"
  default     = "mortru-shared"
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

variable "ar_repository_id" {
  type        = string
  description = "Artifact Registry Docker repository ID"
  default     = "website"
}

variable "ar_keep_count" {
  type        = number
  description = "Number of recent Docker images to retain"
  default     = 5
}

variable "ar_untagged_retention_days" {
  type        = number
  description = "Retention period for untagged images in days"
  default     = 7
}

variable "github_owner" {
  type        = string
  description = "GitHub username or organization name"
  default     = "adammerrill"
}

variable "github_repo" {
  type        = string
  description = "Full GitHub repository slug (owner/repo) for WIF repo-scoped attribute condition"
  default     = "adammerrill/astro-gcp-cloudrun-starter"
}

variable "project_prefix" {
  description = "Prefix to use when creating project IDs and GCS bucket names"
  type        = string
  default     = "mortru"
}

variable "billing_account_id" {
  description = "GCP Billing Account ID"
  type        = string
}

variable "org_id" {
  description = "GCP Organization ID (leave empty if not using)"
  type        = string
  default     = ""
}

variable "folder_id" {
  description = "GCP Folder ID (leave empty if not using)"
  type        = string
  default     = ""
}

variable "region" {
  description = "GCP Region for GCS bucket and projects default"
  type        = string
  default     = "us-central1"
}

variable "developer_email" {
  description = "Email of the developer to grant impersonation access"
  type        = string
}

variable "terraform_service_account_id" {
  description = "The account ID for the Terraform admin service account"
  type        = string
  default     = "sa-terraform-admin"
}


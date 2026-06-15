variable "project_name" {
  description = "Display name for the GCP project"
  type        = string
}

variable "project_id" {
  description = "Unique GCP project ID"
  type        = string
}

variable "billing_account_id" {
  description = "Billing account ID to associate with the project"
  type        = string
}

variable "org_id" {
  description = "Organization ID (leave empty if using folder_id or standalone)"
  type        = string
  default     = ""
}

variable "folder_id" {
  description = "Folder ID to place the project in (leave empty for org root)"
  type        = string
  default     = ""
}

variable "create_project" {
  description = "Whether to create the project (false = use existing project)"
  type        = bool
  default     = true
}

variable "deletion_policy" {
  description = "Project deletion policy: DELETE, ABANDON, or PREVENT"
  type        = string
  default     = "DELETE"
}

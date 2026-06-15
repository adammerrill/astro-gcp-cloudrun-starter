variable "project_id" {
  type = string
}

variable "project_prefix" {
  type    = string
  default = "mortru"
}

variable "environment" {
  type    = string
  default = "shared"
}

variable "primary_region" {
  type    = string
  default = "us-central1"
}

variable "dr_region" {
  type    = string
  default = "us-east1"
}

variable "create_audit_bucket" {
  type    = bool
  default = true
}

variable "audit_log_retention_days" {
  type    = number
  default = 365
}

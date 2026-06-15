variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "repository_id" {
  type    = string
  default = "website"
}

variable "project_prefix" {
  type    = string
  default = "mortru"
}

variable "keep_count" {
  description = "Number of recent image versions to keep"
  type        = number
  default     = 20
}

variable "untagged_retention_days" {
  description = "Days to keep untagged images before cleanup"
  type        = number
  default     = 7
}

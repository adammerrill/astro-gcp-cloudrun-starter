variable "enable" {
  type    = bool
  default = false
}

variable "project_id" {
  type = string
}

variable "project_prefix" {
  type    = string
  default = "mortru"
}

variable "environment" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "cloud_run_service_name" {
  type    = string
  default = "astrowind"
}

variable "ssl_domains" {
  type    = list(string)
  default = ["example.com"]
}

variable "cloud_armor_policy_id" {
  type    = string
  default = null
}

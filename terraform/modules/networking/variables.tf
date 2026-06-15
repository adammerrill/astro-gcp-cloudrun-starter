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

variable "subnet_cidr" {
  type    = string
  default = "10.0.0.0/24"
}

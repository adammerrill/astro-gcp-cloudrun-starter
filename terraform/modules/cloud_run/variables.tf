variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "service_name" {
  type    = string
  default = "astrowind"
}

variable "image" {
  description = "Container image URI. Updated by CI/CD after initial deploy."
  type        = string
  default     = "us-docker.pkg.dev/cloudrun/container/hello"
}

variable "service_account_email" {
  type = string
}

variable "min_instances" {
  description = "Minimum instance count (0 = scale to zero)"
  type        = number
  default     = 0
}

variable "max_instances" {
  description = "Maximum instance count — hard cost ceiling"
  type        = number
  default     = 2
}

variable "cpu_limit" {
  description = "CPU limit per instance"
  type        = string
  default     = "1"
}

variable "memory_limit" {
  description = "Memory limit per instance"
  type        = string
  default     = "256Mi"
}

variable "startup_cpu_boost" {
  description = "Temporarily boost CPU during startup"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Prevent accidental deletion"
  type        = bool
  default     = false
}

variable "ingress" {
  description = "Ingress settings: INGRESS_TRAFFIC_ALL or INGRESS_TRAFFIC_INTERNAL_AND_CLOUD_LOAD_BALANCING"
  type        = string
  default     = "INGRESS_TRAFFIC_ALL"
}

variable "allow_unauthenticated" {
  description = "Allow public access"
  type        = bool
  default     = true
}

variable "secret_env_vars" {
  description = "Environment variables sourced from Secret Manager"
  type = list(object({
    name      = string
    secret_id = string
    version   = string
  }))
  default = []
}

variable "env_vars" {
  description = "Plain environment variables"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

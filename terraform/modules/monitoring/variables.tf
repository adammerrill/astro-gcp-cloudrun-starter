variable "project_id" { type = string }
variable "environment" { type = string }
variable "service_name" { type = string; default = "astrowind" }

variable "uptime_check_host" {
  description = "Hostname for uptime check. Use Cloud Run URL domain."
  type        = string
}

variable "notification_channels" {
  description = "List of notification channel IDs for alerts"
  type        = list(string)
  default     = []
}

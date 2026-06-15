variable "billing_account_id" { type = string }
variable "project_id" { type = string }
variable "environment" { type = string }

variable "monthly_budget_usd" {
  description = "Monthly budget in USD. Change this single value to update spending limits."
  type        = number
  default     = 5
}

variable "notification_channels" {
  description = "Notification channel IDs for budget alerts"
  type        = list(string)
  default     = []
}

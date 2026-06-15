variable "project_id" { type = string }
variable "environment" { type = string }
variable "cloudrun_service_account_email" { type = string }

variable "secrets" {
  description = "Map of secret IDs to create. Values are set externally via gcloud."
  type        = map(string)
  default = {
    # Uncomment when needed:
    # "storyblok-api-key" = "Storyblok CMS API key"
    # "posthog-api-key"   = "PostHog analytics key"
    # "db-password"       = "Cloud SQL password"
  }
}

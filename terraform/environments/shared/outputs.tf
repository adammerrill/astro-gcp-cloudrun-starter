output "project_id" {
  description = "Shared project ID"
  value       = module.project.project_id
}

output "ar_repository_url" {
  description = "Artifact Registry repository URL"
  value       = "${var.region}-docker.pkg.dev/${module.project.project_id}/${var.ar_repository_id}"
}

output "wif_provider_name" {
  description = "Workload Identity Federation provider resource name"
  value       = module.iam.wif_provider_name
}

output "deploy_service_account_email" {
  description = "GitHub Actions deploy service account email"
  value       = module.iam.deploy_service_account_email
}

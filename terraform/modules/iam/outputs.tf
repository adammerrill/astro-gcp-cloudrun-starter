output "cloudrun_service_account_email" {
  description = "Cloud Run service account email"
  value       = google_service_account.cloudrun.email
}

output "deploy_service_account_email" {
  description = "GitHub deploy service account email"
  value       = var.create_wif ? google_service_account.deploy[0].email : ""
}

output "wif_provider_name" {
  description = "Workload Identity Federation provider resource name"
  value       = var.create_wif ? google_iam_workload_identity_pool_provider.github[0].name : ""
}

output "cloudsql_service_account_email" {
  description = "Cloud SQL service account email (empty if disabled)"
  value       = var.enable_cloud_sql ? google_service_account.cloudsql[0].email : ""
}

output "vertex_ai_service_account_email" {
  description = "Vertex AI service account email (empty if disabled)"
  value       = var.enable_vertex_ai ? google_service_account.vertex_ai[0].email : ""
}

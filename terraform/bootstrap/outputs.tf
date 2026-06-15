output "shared_project_id" {
  description = "Shared Project ID"
  value       = google_project.shared.project_id
}

output "dev_project_id" {
  description = "Dev Project ID"
  value       = google_project.dev.project_id
}

output "staging_project_id" {
  description = "Staging Project ID"
  value       = google_project.staging.project_id
}

output "prod_project_id" {
  description = "Production Project ID"
  value       = google_project.prod.project_id
}

output "state_bucket_name" {
  description = "Terraform GCS State Bucket Name"
  value       = google_storage_bucket.tf_state.name
}

output "terraform_admin_sa_email" {
  description = "Terraform Admin Service Account Email"
  value       = google_service_account.tf_admin.email
}

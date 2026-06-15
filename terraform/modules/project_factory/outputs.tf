output "project_id" {
  description = "The project ID"
  value       = local.project_id
}

output "project_number" {
  description = "The project number"
  value       = var.create_project ? google_project.this[0].number : ""
}

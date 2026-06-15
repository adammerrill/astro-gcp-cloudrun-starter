output "service_url" {
  description = "Cloud Run service URL"
  value       = google_cloud_run_v2_service.website.uri
}

output "service_name" {
  value = google_cloud_run_v2_service.website.name
}

output "service_id" {
  value = google_cloud_run_v2_service.website.id
}

output "project_id" {
  description = "Dev project ID"
  value       = module.project.project_id
}

output "service_url" {
  description = "Cloud Run service URL"
  value       = module.cloud_run.service_url
}

output "lb_ip_address" {
  description = "Global LB External IP Address"
  value       = module.load_balancer.lb_ip_address
}

output "db_connection_name" {
  description = "Cloud SQL Connection Name"
  value       = module.cloud_sql.connection_name
}

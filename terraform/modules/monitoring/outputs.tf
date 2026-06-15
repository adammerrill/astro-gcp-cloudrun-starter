output "uptime_check_id" { value = google_monitoring_uptime_check_config.website.uptime_check_id }
output "slo_name" { value = google_monitoring_slo.availability.name }

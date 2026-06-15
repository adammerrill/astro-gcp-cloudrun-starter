output "lb_ip_address" { value = var.enable ? google_compute_global_address.lb[0].address : "" }
output "backend_service_id" { value = var.enable ? google_compute_backend_service.website[0].id : "" }

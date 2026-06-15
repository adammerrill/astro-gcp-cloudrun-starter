output "vpc_id" { value = var.enable ? google_compute_network.vpc[0].id : "" }
output "vpc_self_link" { value = var.enable ? google_compute_network.vpc[0].self_link : "" }
output "subnet_id" { value = var.enable ? google_compute_subnetwork.primary[0].id : "" }

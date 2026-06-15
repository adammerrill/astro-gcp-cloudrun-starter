output "zone_name" { value = var.enable ? google_dns_managed_zone.primary[0].name : "" }
output "name_servers" { value = var.enable ? google_dns_managed_zone.primary[0].name_servers : [] }

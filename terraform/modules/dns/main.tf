# modules/dns — Cloud DNS managed zone (feature-gated)

resource "google_dns_managed_zone" "primary" {
  count = var.enable ? 1 : 0

  name        = "${var.project_prefix}-zone-${var.environment}"
  project     = var.project_id
  dns_name    = "${var.domain}."
  description = "DNS zone for ${var.domain} (${var.environment})"
}

# modules/networking — VPC, subnets, Private Service Access (feature-gated)

resource "google_compute_network" "vpc" {
  count = var.enable ? 1 : 0

  name                    = "${var.project_prefix}-vpc-${var.environment}"
  project                 = var.project_id
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "primary" {
  count = var.enable ? 1 : 0

  name          = "${var.project_prefix}-subnet-${var.environment}"
  project       = var.project_id
  region        = var.region
  network       = google_compute_network.vpc[0].id
  ip_cidr_range = var.subnet_cidr
}

# Private Service Access for Cloud SQL
resource "google_compute_global_address" "private_services" {
  count = var.enable ? 1 : 0

  name          = "private-services-${var.environment}"
  project       = var.project_id
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc[0].id
}

resource "google_service_networking_connection" "private_services" {
  count = var.enable ? 1 : 0

  network                 = google_compute_network.vpc[0].id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_services[0].name]
}

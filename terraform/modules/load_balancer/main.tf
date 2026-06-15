# modules/load_balancer — Global HTTPS LB, SSL, Cloud CDN, Serverless NEG (feature-gated)

# Serverless NEG pointing to Cloud Run
resource "google_compute_region_network_endpoint_group" "cloudrun" {
  count = var.enable ? 1 : 0

  name    = "${var.project_prefix}-neg-${var.environment}"
  project = var.project_id
  region  = var.region

  network_endpoint_type = "SERVERLESS"

  cloud_run {
    service = var.cloud_run_service_name
  }
}

# Backend service with CDN
resource "google_compute_backend_service" "website" {
  count = var.enable ? 1 : 0

  name    = "${var.project_prefix}-backend-${var.environment}"
  project = var.project_id

  protocol              = "HTTP"
  load_balancing_scheme  = "EXTERNAL_MANAGED"
  enable_cdn             = true

  cdn_policy {
    cache_mode                   = "CACHE_ALL_STATIC"
    default_ttl                  = 3600
    max_ttl                      = 86400
    signed_url_cache_max_age     = 0
    serve_while_stale            = 86400
    negative_caching             = true
  }

  backend {
    group = google_compute_region_network_endpoint_group.cloudrun[0].id
  }

  # Cloud Armor policy (attached when cloud_armor is enabled)
  security_policy = var.cloud_armor_policy_id
}

# URL map
resource "google_compute_url_map" "website" {
  count = var.enable ? 1 : 0

  name            = "${var.project_prefix}-urlmap-${var.environment}"
  project         = var.project_id
  default_service = google_compute_backend_service.website[0].id
}

# Google-managed SSL certificate
resource "google_compute_managed_ssl_certificate" "website" {
  count = var.enable ? 1 : 0

  name    = "${var.project_prefix}-ssl-${var.environment}"
  project = var.project_id

  managed {
    domains = var.ssl_domains
  }
}

# HTTPS proxy
resource "google_compute_target_https_proxy" "website" {
  count = var.enable ? 1 : 0

  name    = "${var.project_prefix}-https-proxy-${var.environment}"
  project = var.project_id

  url_map          = google_compute_url_map.website[0].id
  ssl_certificates = [google_compute_managed_ssl_certificate.website[0].id]
}

# Global forwarding rule (external IP)
resource "google_compute_global_forwarding_rule" "https" {
  count = var.enable ? 1 : 0

  name    = "${var.project_prefix}-https-fwd-${var.environment}"
  project = var.project_id

  target                = google_compute_target_https_proxy.website[0].id
  port_range            = "443"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  ip_address            = google_compute_global_address.lb[0].id
}

# Static IP
resource "google_compute_global_address" "lb" {
  count = var.enable ? 1 : 0

  name    = "${var.project_prefix}-lb-ip-${var.environment}"
  project = var.project_id
}

# HTTP → HTTPS redirect
resource "google_compute_url_map" "http_redirect" {
  count = var.enable ? 1 : 0

  name    = "${var.project_prefix}-http-redirect-${var.environment}"
  project = var.project_id

  default_url_redirect {
    https_redirect = true
    strip_query    = false
  }
}

resource "google_compute_target_http_proxy" "http_redirect" {
  count = var.enable ? 1 : 0

  name    = "${var.project_prefix}-http-proxy-${var.environment}"
  project = var.project_id
  url_map = google_compute_url_map.http_redirect[0].id
}

resource "google_compute_global_forwarding_rule" "http_redirect" {
  count = var.enable ? 1 : 0

  name    = "${var.project_prefix}-http-fwd-${var.environment}"
  project = var.project_id

  target                = google_compute_target_http_proxy.http_redirect[0].id
  port_range            = "80"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  ip_address            = google_compute_global_address.lb[0].id
}

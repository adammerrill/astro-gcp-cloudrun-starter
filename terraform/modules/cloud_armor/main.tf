# modules/cloud_armor — Cloud Armor WAF policies (feature-gated)

resource "google_project_service" "compute" {
  count              = var.enable ? 1 : 0
  project            = var.project_id
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_compute_security_policy" "policy" {
  count   = var.enable ? 1 : 0
  project = var.project_id
  name    = "${var.project_prefix}-security-policy-${var.environment}"

  depends_on = [google_project_service.compute]

  # Default rule (allow all traffic)
  rule {
    action   = "allow"
    priority = "2147483647"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "Default rule"
  }

  # Example WAF rule (SQLi prevention)
  rule {
    action   = "deny(403)"
    priority = "1000"
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('sqli-v33-stable')"
      }
    }
    description = "Block SQL injection attacks"
  }

  # Example WAF rule (XSS prevention)
  rule {
    action   = "deny(403)"
    priority = "1001"
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('xss-v33-stable')"
      }
    }
    description = "Block XSS attacks"
  }
}

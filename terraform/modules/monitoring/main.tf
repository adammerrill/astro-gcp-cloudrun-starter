# modules/monitoring — Uptime checks, SLOs, error budgets, alert policies

# ─── Custom service for SLO tracking ───
resource "google_monitoring_custom_service" "website" {
  project      = var.project_id
  service_id   = "website-${var.environment}"
  display_name = "Website (${var.environment})"
}

# ─── Uptime check ───
resource "google_monitoring_uptime_check_config" "website" {
  project      = var.project_id
  display_name = "Website Uptime (${var.environment})"
  timeout      = "10s"
  period       = "300s"

  http_check {
    path           = "/"
    port           = 443
    use_ssl        = true
    validate_ssl   = true
    request_method = "GET"

    accepted_response_status_codes {
      status_class = "STATUS_CLASS_2XX"
    }
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = var.project_id
      host       = var.uptime_check_host
    }
  }
}

# ─── Availability SLO: 99.9% ───
resource "google_monitoring_slo" "availability" {
  service      = google_monitoring_custom_service.website.service_id
  project      = var.project_id
  display_name = "Availability SLO 99.9% (${var.environment})"

  goal                = 0.999
  rolling_period_days = 30

  request_based_sli {
    good_total_ratio {
      good_service_filter  = "metric.type=\"run.googleapis.com/request_count\" resource.type=\"cloud_run_revision\" resource.label.\"service_name\"=\"${var.service_name}\" metric.label.\"response_code_class\"=\"2xx\""
      total_service_filter = "metric.type=\"run.googleapis.com/request_count\" resource.type=\"cloud_run_revision\" resource.label.\"service_name\"=\"${var.service_name}\""
    }
  }
}

# ─── Error budget burn rate alert ───
resource "google_monitoring_alert_policy" "error_budget_burn" {
  project      = var.project_id
  display_name = "Error Budget Burn Rate (${var.environment})"
  combiner     = "OR"

  conditions {
    display_name = "SLO burn rate > 2x over 1 hour"

    condition_threshold {
      filter          = "select_slo_burn_rate(\"${google_monitoring_slo.availability.name}\", \"3600s\")"
      comparison      = "COMPARISON_GT"
      threshold_value = 2.0
      duration        = "0s"

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_NEXT_OLDER"
      }
    }
  }

  notification_channels = var.notification_channels

  alert_strategy {
    auto_close = "604800s"
  }
}

# ─── Uptime failure alert ───
resource "google_monitoring_alert_policy" "uptime_failure" {
  project      = var.project_id
  display_name = "Uptime Check Failed (${var.environment})"
  combiner     = "OR"

  conditions {
    display_name = "Uptime check failing"

    condition_threshold {
      filter          = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${google_monitoring_uptime_check_config.website.uptime_check_id}\""
      comparison      = "COMPARISON_GT"
      threshold_value = 1
      duration        = "300s"

      aggregations {
        alignment_period     = "300s"
        per_series_aligner   = "ALIGN_NEXT_OLDER"
        cross_series_reducer = "REDUCE_COUNT_FALSE"
        group_by_fields      = ["resource.label.project_id"]
      }
    }
  }

  notification_channels = var.notification_channels
}

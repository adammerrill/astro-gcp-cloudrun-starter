# modules/storage — GCS buckets for TF state, backups, and DR

resource "google_storage_bucket" "tf_state" {
  count    = var.create_state_bucket ? 1 : 0
  name     = "${var.project_prefix}-tf-state"
  location = var.primary_region
  project  = var.project_id

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      num_newer_versions = 30
    }
    action {
      type = "Delete"
    }
  }
}

# DR state bucket in secondary region
resource "google_storage_bucket" "tf_state_dr" {
  count    = var.create_state_bucket ? 1 : 0
  name     = "${var.project_prefix}-tf-state-dr"
  location = var.dr_region
  project  = var.project_id

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  versioning {
    enabled = true
  }
}

# Audit log export bucket
resource "google_storage_bucket" "audit_logs" {
  count = var.create_audit_bucket ? 1 : 0

  name     = "${var.project_prefix}-audit-logs-${var.environment}"
  location = var.primary_region
  project  = var.project_id

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  lifecycle_rule {
    condition {
      age = var.audit_log_retention_days
    }
    action {
      type = "Delete"
    }
  }
}

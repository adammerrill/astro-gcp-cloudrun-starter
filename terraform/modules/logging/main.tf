# modules/logging — Audit log exports and log sinks

resource "google_logging_project_sink" "audit_export" {
  name    = "audit-log-export-${var.environment}"
  project = var.project_id

  destination            = "storage.googleapis.com/${var.audit_bucket_name}"
  filter                 = "logName:\"cloudaudit.googleapis.com\""
  unique_writer_identity = true
}

# Grant the log sink writer access to the audit bucket
resource "google_storage_bucket_iam_member" "audit_sink_writer" {
  bucket = var.audit_bucket_name
  role   = "roles/storage.objectCreator"
  member = google_logging_project_sink.audit_export.writer_identity
}

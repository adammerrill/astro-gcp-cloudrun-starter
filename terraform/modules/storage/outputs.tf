output "tf_state_bucket" { value = google_storage_bucket.tf_state.name }
output "tf_state_dr_bucket" { value = google_storage_bucket.tf_state_dr.name }
output "audit_logs_bucket" { value = var.create_audit_bucket ? google_storage_bucket.audit_logs[0].name : "" }

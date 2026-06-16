output "tf_state_bucket" { value = try(google_storage_bucket.tf_state[0].name, "") }
output "tf_state_dr_bucket" { value = try(google_storage_bucket.tf_state_dr[0].name, "") }
output "audit_logs_bucket" { value = var.create_audit_bucket ? google_storage_bucket.audit_logs[0].name : "" }

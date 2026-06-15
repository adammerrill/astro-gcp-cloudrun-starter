output "policy_id" {
  value       = var.enable ? google_compute_security_policy.policy[0].id : null
  description = "The security policy ID"
}

output "policy_self_link" {
  value       = var.enable ? google_compute_security_policy.policy[0].self_link : null
  description = "The security policy self-link"
}

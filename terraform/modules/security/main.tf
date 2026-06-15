# modules/security — SCC, Cloud Asset Inventory, IAM Analyzer

# Enable Security Command Center API
resource "google_project_service" "scc" {
  project = var.project_id
  service = "securitycenter.googleapis.com"

  disable_on_destroy = false
}

# Enable Cloud Asset Inventory API
resource "google_project_service" "cai" {
  project = var.project_id
  service = "cloudasset.googleapis.com"

  disable_on_destroy = false
}

# Enable IAM Recommender (auto-enabled, but explicit for clarity)
resource "google_project_service" "recommender" {
  project = var.project_id
  service = "recommender.googleapis.com"

  disable_on_destroy = false
}

# Enable Policy Analyzer
resource "google_project_service" "policy_analyzer" {
  project = var.project_id
  service = "policyanalyzer.googleapis.com"

  disable_on_destroy = false
}

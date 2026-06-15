# modules/iam — Service accounts, Workload Identity Federation, role bindings

# ─── Cloud Run service account ───
resource "google_service_account" "cloudrun" {
  project      = var.project_id
  account_id   = "sa-cloudrun-${var.environment}"
  display_name = "Cloud Run Website (${var.environment})"
}

resource "google_project_iam_member" "cloudrun_log_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.cloudrun.email}"
}

resource "google_project_iam_member" "cloudrun_metric_writer" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.cloudrun.email}"
}

resource "google_project_iam_member" "cloudrun_secret_accessor" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.cloudrun.email}"
}

# ─── Cross-project AR read (pull images from shared project) ───
resource "google_project_iam_member" "cloudrun_ar_reader" {
  count   = var.shared_project_id != "" ? 1 : 0
  project = var.shared_project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.cloudrun.email}"
}

# ─── Workload Identity Federation (shared project only) ───
resource "google_iam_workload_identity_pool" "github" {
  count = var.create_wif ? 1 : 0

  project                   = var.project_id
  workload_identity_pool_id = "github-pool"
  display_name              = "GitHub Actions Pool"
}

resource "google_iam_workload_identity_pool_provider" "github" {
  count = var.create_wif ? 1 : 0

  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github[0].workload_identity_pool_id
  workload_identity_pool_provider_id = "github-provider"
  display_name                       = "GitHub OIDC Provider"

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.repository" = "assertion.repository"
    "attribute.owner"      = "assertion.repository_owner"
  }

  attribute_condition = "assertion.repository_owner == '${var.github_owner}'"

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

# ─── Deploy service account (shared project — used by GitHub Actions) ───
resource "google_service_account" "deploy" {
  count = var.create_wif ? 1 : 0

  project      = var.project_id
  account_id   = "sa-github-deploy"
  display_name = "GitHub Actions Deploy"
}

resource "google_service_account_iam_member" "deploy_wif_binding" {
  count = var.create_wif ? 1 : 0

  service_account_id = google_service_account.deploy[0].name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github[0].name}/attribute.owner/${var.github_owner}"
}

resource "google_project_iam_member" "deploy_ar_writer" {
  count = var.create_wif ? 1 : 0

  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.deploy[0].email}"
}

# ─── Feature-gated service accounts ───
resource "google_service_account" "cloudsql" {
  count = var.enable_cloud_sql ? 1 : 0

  project      = var.project_id
  account_id   = "sa-cloudsql-${var.environment}"
  display_name = "Cloud SQL Client (${var.environment})"
}

resource "google_project_iam_member" "cloudsql_client" {
  count = var.enable_cloud_sql ? 1 : 0

  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.cloudsql[0].email}"
}

resource "google_service_account" "vertex_ai" {
  count = var.enable_vertex_ai ? 1 : 0

  project      = var.project_id
  account_id   = "sa-vertex-ai-${var.environment}"
  display_name = "Vertex AI (${var.environment})"
}

resource "google_project_iam_member" "vertex_ai_user" {
  count = var.enable_vertex_ai ? 1 : 0

  project = var.project_id
  role    = "roles/aiplatform.user"
  member  = "serviceAccount:${google_service_account.vertex_ai[0].email}"
}

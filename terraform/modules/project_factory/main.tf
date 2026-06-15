# modules/project_factory — Creates a GCP project and enables required APIs
# Used by each environment to bootstrap its own project

resource "google_project" "this" {
  count = var.create_project ? 1 : 0

  name            = var.project_name
  project_id      = var.project_id
  billing_account = var.billing_account_id
  org_id          = var.org_id != "" ? var.org_id : null
  folder_id       = var.folder_id != "" ? var.folder_id : null
  deletion_policy = var.deletion_policy
}

locals {
  project_id = var.create_project ? google_project.this[0].project_id : var.project_id

  # APIs to enable — Day 1 services only
  # Feature-gated APIs are enabled by their respective modules
  apis = [
    "run.googleapis.com",
    "artifactregistry.googleapis.com",
    "secretmanager.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com",
    "cloudasset.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "billingbudgets.googleapis.com",
  ]
}

resource "google_project_service" "apis" {
  for_each = toset(local.apis)

  project = local.project_id
  service = each.value

  disable_dependent_services = false
  disable_on_destroy         = false
}

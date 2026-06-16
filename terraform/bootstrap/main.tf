# terraform/bootstrap/main.tf — GCP Seed Bootstrap (creates projects, state bucket, and admin SA)

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

provider "google" {}

# ─── GCP Projects ───

resource "google_project" "shared" {
  name            = "${var.project_prefix} Shared"
  project_id      = "${var.project_prefix}-shared"
  billing_account = var.billing_account_id
  org_id          = var.org_id != "" ? var.org_id : null
  folder_id       = var.folder_id != "" ? var.folder_id : null
  deletion_policy = "DELETE"
}

resource "google_project" "dev" {
  name            = "${var.project_prefix} Dev"
  project_id      = "${var.project_prefix}-dev"
  billing_account = var.billing_account_id
  org_id          = var.org_id != "" ? var.org_id : null
  folder_id       = var.folder_id != "" ? var.folder_id : null
  deletion_policy = "DELETE"
}

resource "google_project" "staging" {
  name            = "${var.project_prefix} Staging"
  project_id      = "${var.project_prefix}-staging"
  billing_account = var.billing_account_id
  org_id          = var.org_id != "" ? var.org_id : null
  folder_id       = var.folder_id != "" ? var.folder_id : null
  deletion_policy = "DELETE"
}

resource "google_project" "prod" {
  name            = "${var.project_prefix} Production"
  project_id      = "${var.project_prefix}-prod"
  billing_account = var.billing_account_id
  org_id          = var.org_id != "" ? var.org_id : null
  folder_id       = var.folder_id != "" ? var.folder_id : null
  deletion_policy = "DELETE"
}

# ─── Seed APIs ───

locals {
  seed_apis = [
    "cloudbilling.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "artifactregistry.googleapis.com",
    "run.googleapis.com",
    "secretmanager.googleapis.com",
    "serviceusage.googleapis.com",
    "storage.googleapis.com",
  ]
  projects = {
    shared  = google_project.shared.project_id
    dev     = google_project.dev.project_id
    staging = google_project.staging.project_id
    prod    = google_project.prod.project_id
  }
  project_services = flatten([
    for p_key, p_id in local.projects : [
      for api in local.seed_apis : {
        key        = "${p_key}-${api}"
        project_id = p_id
        service    = api
      }
    ]
  ])
}

resource "google_project_service" "seed" {
  for_each = { for ps in local.project_services : ps.key => ps }

  project = each.value.project_id
  service = each.value.service

  disable_on_destroy         = false
  disable_dependent_services = false
}

# ─── GCS State Bucket ───

resource "google_storage_bucket" "tf_state" {
  name     = "${var.project_prefix}-tf-state"
  project  = google_project.shared.project_id
  location = var.region

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

  depends_on = [google_project_service.seed]
}

# ─── Automation Service Account ───

resource "google_service_account" "tf_admin" {
  project      = google_project.shared.project_id
  account_id   = var.terraform_service_account_id
  display_name = "Terraform Admin Service Account"

  depends_on = [google_project_service.seed]
}

resource "google_service_account_iam_member" "token_creator" {
  service_account_id = google_service_account.tf_admin.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "user:${var.developer_email}"
}

# ─── Project roles for Admin SA ───

locals {
  admin_roles = [
    "roles/editor",
    "roles/resourcemanager.projectIamAdmin",
  ]
  project_roles = flatten([
    for p_key, p_id in local.projects : [
      for role in local.admin_roles : {
        key        = "${p_key}-${role}"
        project_id = p_id
        role       = role
      }
    ]
  ])
}

resource "google_project_iam_member" "tf_admin_roles" {
  for_each = { for pr in local.project_roles : pr.key => pr }

  project = each.value.project_id
  role    = each.value.role
  member  = "serviceAccount:${google_service_account.tf_admin.email}"
}

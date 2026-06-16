# environments/shared/main.tf

module "project" {
  source = "../../modules/project_factory"

  create_project     = var.create_project
  project_name       = var.project_name
  project_id         = var.project_id
  billing_account_id = var.billing_account_id
  org_id             = var.org_id
  folder_id          = var.folder_id
  deletion_policy    = var.deletion_policy
}

module "artifact_registry" {
  source     = "../../modules/artifact_registry"
  project_id = module.project.project_id

  region                  = var.region
  repository_id           = var.ar_repository_id
  project_prefix          = var.project_prefix
  keep_count              = var.ar_keep_count
  untagged_retention_days = var.ar_untagged_retention_days

  depends_on = [module.project]
}

module "iam" {
  source     = "../../modules/iam"
  project_id = module.project.project_id

  environment  = "shared"
  create_wif   = true
  github_owner = var.github_owner
  github_repo  = var.github_repo

  depends_on = [module.project]
}

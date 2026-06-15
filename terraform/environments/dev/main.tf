# environments/dev/main.tf

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

module "iam" {
  source = "../../modules/iam"

  project_id        = module.project.project_id
  environment       = var.environment
  shared_project_id = var.shared_project_id
  create_wif        = false
  enable_cloud_sql  = var.enable_cloud_sql
  enable_vertex_ai  = var.enable_vertex_ai

  depends_on = [module.project]
}

module "storage" {
  source = "../../modules/storage"

  project_id               = module.project.project_id
  project_prefix           = var.project_prefix
  environment              = var.environment
  primary_region           = var.region
  dr_region                = var.dr_region
  create_audit_bucket      = true
  audit_log_retention_days = var.audit_log_retention_days

  depends_on = [module.project]
}

module "secret_manager" {
  source = "../../modules/secret_manager"

  project_id                     = module.project.project_id
  environment                    = var.environment
  cloudrun_service_account_email = module.iam.cloudrun_service_account_email
  secrets                        = var.secrets

  depends_on = [module.project]
}

module "cloud_run" {
  source = "../../modules/cloud_run"

  project_id            = module.project.project_id
  region                = var.region
  service_name          = var.service_name
  image                 = var.image
  service_account_email = module.iam.cloudrun_service_account_email
  min_instances         = var.cloud_run_min_instances
  max_instances         = var.cloud_run_max_instances
  cpu_limit             = var.cloud_run_cpu_limit
  memory_limit          = var.cloud_run_memory_limit
  startup_cpu_boost     = var.cloud_run_startup_cpu_boost
  deletion_protection   = var.cloud_run_deletion_protection
  ingress               = var.cloud_run_ingress
  allow_unauthenticated = var.cloud_run_allow_unauthenticated
  secret_env_vars       = var.cloud_run_secret_env_vars
  env_vars              = var.cloud_run_env_vars

  depends_on = [module.project]
}

module "monitoring" {
  source = "../../modules/monitoring"

  project_id            = module.project.project_id
  environment           = var.environment
  service_name          = var.service_name
  uptime_check_host     = var.uptime_check_host != "" ? var.uptime_check_host : replace(module.cloud_run.service_url, "https://", "")
  notification_channels = var.notification_channels

  depends_on = [module.project, module.cloud_run]
}

module "logging" {
  source = "../../modules/logging"

  project_id        = module.project.project_id
  environment       = var.environment
  audit_bucket_name = module.storage.audit_logs_bucket

  depends_on = [module.project, module.storage]
}

module "security" {
  source = "../../modules/security"

  project_id = module.project.project_id

  depends_on = [module.project]
}

module "cost_governance" {
  source = "../../modules/cost_governance"

  billing_account_id    = var.billing_account_id
  project_id            = module.project.project_id
  environment           = var.environment
  monthly_budget_usd    = var.monthly_budget_usd
  notification_channels = var.notification_channels

  depends_on = [module.project]
}

# ─── Feature-Gated Modules ───

module "networking" {
  source = "../../modules/networking"

  enable         = var.enable_networking
  project_id     = module.project.project_id
  project_prefix = var.project_prefix
  environment    = var.environment
  region         = var.region
  subnet_cidr    = var.subnet_cidr

  depends_on = [module.project]
}

module "dns" {
  source = "../../modules/dns"

  enable         = var.enable_dns
  project_id     = module.project.project_id
  project_prefix = var.project_prefix
  environment    = var.environment
  domain         = var.domain

  depends_on = [module.project]
}

module "cloud_armor" {
  source = "../../modules/cloud_armor"

  enable         = var.enable_cloud_armor
  project_id     = module.project.project_id
  project_prefix = var.project_prefix
  environment    = var.environment

  depends_on = [module.project]
}

module "load_balancer" {
  source = "../../modules/load_balancer"

  enable                 = var.enable_load_balancer
  project_id             = module.project.project_id
  project_prefix         = var.project_prefix
  environment            = var.environment
  region                 = var.region
  cloud_run_service_name = var.service_name
  ssl_domains            = [var.domain]
  cloud_armor_policy_id  = module.cloud_armor.policy_id

  depends_on = [module.project, module.cloud_run, module.cloud_armor]
}

module "cloud_sql" {
  source = "../../modules/cloud_sql"

  enable              = var.enable_cloud_sql
  project_id          = module.project.project_id
  project_prefix      = var.project_prefix
  environment         = var.environment
  region              = var.region
  vpc_network_id      = module.networking.vpc_id
  tier                = var.db_tier
  deletion_protection = var.db_deletion_protection
  pitr_enabled        = var.db_pitr_enabled
  db_name             = var.db_name
  db_user             = var.db_user
  db_password         = var.db_password

  depends_on = [module.project, module.networking]
}

module "vertex_ai" {
  source = "../../modules/vertex_ai"

  enable         = var.enable_vertex_ai
  project_id     = module.project.project_id
  project_prefix = var.project_prefix
  environment    = var.environment
  region         = var.region

  depends_on = [module.project]
}

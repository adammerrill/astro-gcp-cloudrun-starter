# environments/dev/terraform.tfvars

billing_account_id = "000000-000000-000000" # Update with your GCP Billing Account ID
project_id         = "mortru-dev"
project_prefix     = "mortru"
region             = "us-central1"
dr_region          = "us-east1"
environment        = "dev"
shared_project_id  = "mortru-shared"

# Cost ceiling
monthly_budget_usd = 5

# Cloud Run limits
cloud_run_min_instances = 0
cloud_run_max_instances = 2
cloud_run_cpu_limit     = "0.5"
cloud_run_memory_limit  = "256Mi"

# Feature Gates (Disabled by default on Day 1 for cost-efficiency)
enable_networking    = false
enable_dns           = false
enable_cloud_armor   = false
enable_load_balancer = false
enable_cloud_sql     = false
enable_vertex_ai     = false

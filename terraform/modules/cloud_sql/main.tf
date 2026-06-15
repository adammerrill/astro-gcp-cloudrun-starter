# modules/cloud_sql — Cloud SQL PostgreSQL (feature-gated)

resource "google_project_service" "sqladmin" {
  count              = var.enable ? 1 : 0
  project            = var.project_id
  service            = "sqladmin.googleapis.com"
  disable_on_destroy = false
}

resource "google_sql_database_instance" "postgres" {
  count   = var.enable ? 1 : 0
  project = var.project_id
  name    = "${var.project_prefix}-sql-${var.environment}"
  region  = var.region

  database_version = "POSTGRES_16"

  depends_on = [google_project_service.sqladmin]

  settings {
    tier = var.tier

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.vpc_network_id
    }

    backup_configuration {
      enabled                        = true
      start_time                     = "02:00"
      point_in_time_recovery_enabled = var.pitr_enabled
    }

    location_preference {
      zone = "${var.region}-a"
    }
  }

  deletion_protection = var.deletion_protection
}

resource "google_sql_database" "db" {
  count    = var.enable ? 1 : 0
  project  = var.project_id
  name     = var.db_name
  instance = google_sql_database_instance.postgres[0].name
}

resource "google_sql_user" "user" {
  count    = var.enable ? 1 : 0
  project  = var.project_id
  name     = var.db_user
  instance = google_sql_database_instance.postgres[0].name
  password = var.db_password
}

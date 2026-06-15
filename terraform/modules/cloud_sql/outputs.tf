output "connection_name" {
  value       = var.enable ? google_sql_database_instance.postgres[0].connection_name : ""
  description = "The connection name of the database instance"
}

output "private_ip_address" {
  value       = var.enable ? google_sql_database_instance.postgres[0].private_ip_address : ""
  description = "The private IP address of the database instance"
}

output "db_name" {
  value       = var.enable ? google_sql_database.db[0].name : ""
  description = "The database name"
}

output "db_user" {
  value       = var.enable ? google_sql_user.user[0].name : ""
  description = "The database username"
}

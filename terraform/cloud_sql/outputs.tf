output "main_instance_sql_ipv4" {
  value       = google_sql_database_instance.main.ip_address.0.ip_address
  description = "The IPv4 address assigned for main"
}

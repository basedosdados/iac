# GCP variables
variable "region" {
  description = "Region of resources"
}

variable "sql_version" {
  description = "SQL Version"
}

variable "sql_instance_tier" {
  description = "SQL Instance Tier"
}

variable "sql_disk_size" {
  description = "SQL Disk Size"
}

variable "sql_disk_autoresize" {
  description = "SQL Disk Auto Resize"
}

variable "sql_backup_enabled" {
  description = "SQL Backup Enabled"
}

variable "sql_ckan_staging_user_name" {
  description = "SQL CKAN-Staging User Name"
}

variable "sql_ckan_staging_user_password" {
  description = "SQL CKAN-Staging User Password"
}

variable "sql_ckan_staging_db_name" {
  description = "SQL CKAN-Staging DB Name"
}

variable "sql_ckan_production_user_name" {
  description = "SQL CKAN-Production User Name"
}

variable "sql_ckan_production_user_password" {
  description = "SQL CKAN-Production User Password"
}

variable "sql_ckan_production_db_name" {
  description = "SQL CKAN-Production DB Name"
}

variable "sql_metabase_user_name" {
  description = "SQL Metabase User Name"
}
variable "sql_metabase_user_password" {
  description = "SQL Metabase User Password"
}

variable "sql_metabase_db_name" {
  description = "SQL Metabase DB Name"
}

variable "sql_prefect_user_name" {
  description = "SQL Prefect User Name"
}

variable "sql_prefect_user_password" {
  description = "SQL Prefect User Password"
}

variable "sql_prefect_db_name" {
  description = "SQL Prefect DB Name"
}

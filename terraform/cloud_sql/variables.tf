############################################################################
# Common
############################################################################
variable "project_id" {
  type        = string
  description = "The GCP project ID to use."
}

variable "region" {
  type        = string
  description = "The main GCP region to use."
}

############################################################################
# Cloud SQL
############################################################################
variable "sql_version" {
  type        = string
  description = "The version of Cloud SQL to use."
}

variable "sql_instance_tier" {
  type        = string
  description = "The tier of Cloud SQL to use."
}

variable "sql_disk_size" {
  type        = string
  description = "The size of the disk for the Cloud SQL instance."
}

variable "sql_disk_autoresize" {
  type        = string
  description = "Whether the disk for the Cloud SQL instance should be resized automatically."
}

variable "sql_backup_enabled" {
  type        = string
  description = "Whether the Cloud SQL instance should have backup enabled."
}

variable "sql_backup_start_time" {
  type        = string
  description = "The time at which the backup should start."
}

variable "sql_ckan_production_user_name" {
  type        = string
  description = "The name of the CKAN production user."
}

variable "sql_ckan_production_user_password" {
  type        = string
  description = "The password of the CKAN production user."
}

variable "sql_ckan_production_db_name" {
  type        = string
  description = "The name of the CKAN production database."
}

variable "sql_ckan_staging_user_name" {
  type        = string
  description = "The name of the CKAN staging user."
}

variable "sql_ckan_staging_user_password" {
  type        = string
  description = "The password of the CKAN staging user."
}

variable "sql_ckan_staging_db_name" {
  type        = string
  description = "The name of the CKAN staging database."
}

variable "sql_metabase_user_name" {
  type        = string
  description = "The name of the Metabase user."
}

variable "sql_metabase_user_password" {
  type        = string
  description = "The password of the Metabase user."
}

variable "sql_metabase_db_name" {
  type        = string
  description = "The name of the Metabase database."
}

variable "sql_prefect_user_name" {
  type        = string
  description = "The name of the user to create for the Prefect database."
}

variable "sql_prefect_user_password" {
  type        = string
  description = "The password of the user to create for the Prefect database."
}

variable "sql_prefect_db_name" {
  type        = string
  description = "The name of the Prefect database."
}

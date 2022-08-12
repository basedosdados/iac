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

variable "zone" {
  type        = string
  description = "The main GCP zone to use for the cluster."
}

############################################################################
# Cloud SQL
############################################################################
variable "sql_version" {
  type        = string
  description = "The version of Cloud SQL to use."
}

variable "sql_deletion_protection" {
  type        = bool
  description = "Whether to enable deletion protection for the Cloud SQL instance."
}

variable "sql_instance_tier" {
  type        = string
  description = "The tier of Cloud SQL to use."
}

variable "sql_disk_size" {
  type        = number
  description = "The size of the disk for the Cloud SQL instance."
}

variable "sql_disk_autoresize" {
  type        = bool
  description = "Whether the disk for the Cloud SQL instance should be resized automatically."
}

variable "sql_disk_autoresize_limit" {
  type        = number
  description = "The maximum size of the disk auto resize for the Cloud SQL instance."
}

variable "sql_backup_enabled" {
  type        = bool
  description = "Whether the Cloud SQL instance should have backup enabled."
}

variable "sql_backup_start_time" {
  type        = string
  description = "The time at which the backup should start."
}

variable "sql_backup_location" {
  type        = string
  description = "The GCS location to use for the Cloud SQL instance backup."
}

variable "sql_db_max_connections" {
  type        = number
  description = "The maximum number of connections for the Cloud SQL instance."
}

variable "sql_ckan_production_user_name" {
  type        = string
  description = "The name of the CKAN production database user."
  default     = "ckan_production"
}

variable "sql_ckan_production_user_password" {
  type        = string
  description = "The password of the CKAN production database user."
  sensitive   = true
}

variable "sql_ckan_production_db_name" {
  type        = string
  description = "The name of the CKAN production database."
  default     = "ckan_production"
}

variable "sql_ckan_staging_user_name" {
  type        = string
  description = "The name of the CKAN staging database user."
  default     = "ckan_staging"
}

variable "sql_ckan_staging_user_password" {
  type        = string
  description = "The password of the CKAN staging user."
  sensitive   = true
}

variable "sql_ckan_staging_db_name" {
  type        = string
  description = "The name of the CKAN staging database."
  default     = "ckan_staging"
}

variable "sql_id_server_user_name" {
  type        = string
  description = "The name of the ID server database user."
  default     = "id_basedosdados"
}

variable "sql_id_server_user_password" {
  type        = string
  description = "The password of the ID server database user."
  sensitive   = true
}

variable "sql_id_server_db_name" {
  type        = string
  description = "The name of the ID server database."
  default     = "id_basedosdados"
}

variable "sql_metabase_user_name" {
  type        = string
  description = "The name of the Metabase database user."
  default     = "metabase"
}

variable "sql_metabase_user_password" {
  type        = string
  description = "The password of the Metabase database user."
  sensitive   = true
}

variable "sql_metabase_db_name" {
  type        = string
  description = "The name of the Metabase database."
  default     = "metabase"
}

variable "sql_prefect_user_name" {
  type        = string
  description = "The name of the Prefect database user."
  default     = "prefect"
}

variable "sql_prefect_user_password" {
  type        = string
  description = "The password of the Prefect database user."
  sensitive   = true
}

variable "sql_prefect_db_name" {
  type        = string
  description = "The name of the Prefect database."
  default     = "prefect"
}

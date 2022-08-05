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

variable "sql_backup_enabled" {
  type        = bool
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
  sensitive   = true
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
  sensitive   = true
}

variable "sql_ckan_staging_db_name" {
  type        = string
  description = "The name of the CKAN staging database."
}

variable "sql_id_basedosdados_user_name" {
  type        = string
  description = "The name of the ID basedosdados user."
}

variable "sql_id_basedosdados_user_password" {
  type        = string
  description = "The password of the ID basedosdados user."
  sensitive   = true
}

variable "sql_id_basedosdados_db_name" {
  type        = string
  description = "The name of the ID basedosdados database."
}

variable "sql_metabase_user_name" {
  type        = string
  description = "The name of the Metabase user."
}

variable "sql_metabase_user_password" {
  type        = string
  description = "The password of the Metabase user."
  sensitive   = true
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
  sensitive   = true
}

variable "sql_prefect_db_name" {
  type        = string
  description = "The name of the Prefect database."
}

############################################################################
# GKE
############################################################################
variable "static_pool_machine_type" {
  type        = string
  description = "The machine type to use for the cluster's static pool."
}

variable "static_pool_node_count" {
  type        = number
  description = "The number of nodes to use for the static pool."
}

variable "dynamic_pool_machine_type" {
  type        = string
  description = "The machine type to use for the cluster's dynamic pool."
}

variable "dynamic_pool_node_count" {
  type        = number
  description = "The default number of nodes to use for the dynamic pool."
}

variable "dynamic_pool_node_min" {
  type        = number
  description = "The minimum number of nodes to use for the dynamic pool."
}

variable "dynamic_pool_node_max" {
  type        = number
  description = "The maximum number of nodes to use for the dynamic pool."
}

variable "dynamic_pool_node_preemptible" {
  type        = bool
  description = "Whether to use preemptible nodes for the dynamic pool."
}

############################################################################
# IAM
############################################################################
variable "gsa_cloudsql_account_id" {
  type        = string
  description = "Cloud SQL Account ID"
}

variable "role_iam_workload_identity_user" {
  type        = string
  description = "IAM workload identity user role."
}

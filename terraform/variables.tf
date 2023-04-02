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
  description = "The GCP location to use for the Cloud SQL instance backup."
}

variable "sql_db_max_connections" {
  type        = number
  description = "The maximum number of connections for the Cloud SQL instance."
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

############################################################################
# Cloud SQL MySQL
############################################################################
variable "sql_version_mysql" {
  type        = string
  description = "The version of Cloud SQL MySQL to use."
}

variable "sql_passbolt_user_name" {
  type        = string
  description = "The name of the Passbolt production database user."
  default     = "passbolt"
}

variable "sql_passbolt_user_password" {
  type        = string
  description = "The password of the Passbolt production database user."
  sensitive   = true
}

variable "sql_passbolt_db_name" {
  type        = string
  description = "The name of the Passbolt production database."
  default     = "passbolt"
}

############################################################################
# Cloud Storage
############################################################################
variable "bucket_name" {
  type        = string
  description = "The name of the bucket."
}

variable "bucket_uniform_bucket_level_access" {
  type        = bool
  description = "Whether to enable Uniform Bucket-Level Access for the bucket."
  default     = true
}

variable "bucket_versioning" {
  type        = bool
  description = "Whether to enable versioning for the bucket."
  default     = true
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

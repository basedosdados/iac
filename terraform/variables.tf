############
#
# Common
#
############

variable "project_id" {
  description = "The GCP project ID to use for the cluster."
}

variable "bucket_name" {
  description = "Name of the GCS bucket for storing Terraform data"
}

variable "region" {
  default     = "us-central1"
  description = "The GCP region to use for the cluster."
}

variable "zone" {
  default     = "us-central1-c"
  description = "The GCP zone to use for the cluster."
}

############
#
# Cloud SQL
#
############

variable "sql_version" {
  default     = "POSTGRES_13"
  description = "SQL Version"
}

variable "sql_instance_tier" {
  default     = "db-f1-micro"
  description = "SQL Instance Tier"
}

variable "sql_disk_size" {
  default     = "80"
  description = "SQL Disk Size"
}

variable "sql_disk_autoresize" {
  default     = true
  description = "SQL Disk Auto Resize"
}

variable "sql_backup_enabled" {
  default     = true
  description = "SQL Backup Enabled"
}

variable "sql_ckan_staging_user_name" {
  default     = "ckan_staging"
  description = "SQL CKAN-Staging User Name"
}

variable "sql_ckan_staging_user_password" {
  description = "SQL CKAN-Staging User Password"
}

variable "sql_ckan_staging_db_name" {
  default     = "ckan_staging"
  description = "SQL CKAN-Staging DB Name"
}

variable "sql_ckan_production_user_name" {
  default     = "ckan_production"
  description = "SQL CKAN-Production User Name"
}

variable "sql_ckan_production_user_password" {
  description = "SQL CKAN-Production User Password"
}

variable "sql_ckan_production_db_name" {
  default     = "ckan_production"
  description = "SQL CKAN-Production DB Name"
}

variable "sql_metabase_user_name" {
  default     = "metabase"
  description = "SQL Metabase User Name"
}
variable "sql_metabase_user_password" {
  description = "SQL Metabase User Password"
}

variable "sql_metabase_db_name" {
  default     = "metabase"
  description = "SQL Metabase DB Name"
}

variable "sql_prefect_user_name" {
  default     = "prefect"
  description = "SQL Prefect User Name"
}

variable "sql_prefect_user_password" {
  description = "SQL Prefect User Password"
}

variable "sql_prefect_db_name" {
  default     = "prefect"
  description = "SQL Prefect DB Name"
}

############
#
# GKE
#
############

variable "static_pool_machine_type" {
  description = "The machine type to use for the cluster's static pool."
  default     = "n1-standard-4"
}

variable "static_pool_node_count" {
  description = "The number of nodes to use for the static pool."
  default     = 2
}

variable "dynamic_pool_machine_type" {
  description = "The machine type to use for the cluster's dynamic pool."
  default     = "e2-medium"
}

variable "dynamic_pool_node_count" {
  description = "The default number of nodes to use for the dynamic pool."
  default     = 0
}

variable "dynamic_pool_node_min" {
  description = "The minimum number of nodes to use for the dynamic pool."
  default     = 0
}

variable "dynamic_pool_node_max" {
  description = "The maximum number of nodes to use for the dynamic pool."
  default     = 1
}

variable "dynamic_pool_node_preemptible" {
  description = "Whether to use preemptible nodes for the dynamic pool."
  default     = true
}

############
#
# IAM
#
############
variable "gsa_cloudsql_account_id" {
  description = "Cloud SQL Account ID"
  default     = "gsa-cloudsql"
}

variable "role_iam_workload_identity_user" {
  description = "IAM workload identity user role."
  default     = "roles/iam.workloadIdentityUser"
}

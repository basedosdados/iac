############
#
# Common
#
############

variable "project_id" {
  type        = string
  description = "The GCP project ID to use for the cluster."
  default     = "basedosdados-dev"
}

variable "bucket_name" {
  type        = string
  description = "Name of the GCS bucket for storing Terraform data"
  default     = "terraform-data-basedosdados-dev"
}

variable "region" {
  type        = string
  description = "The GCP region to use for the cluster."
  default     = "us-central1"
}

variable "zone" {
  type        = string
  description = "The GCP zone to use for the cluster."
  default     = "us-central1-c"
}

############
#
# Cloud SQL
#
############

variable "sql_version" {
  type        = string
  description = "SQL Version"
  default     = "POSTGRES_13"
}

variable "sql_instance_tier" {
  type        = string
  description = "SQL Instance Tier"
  default     = "db-f1-micro"
}

variable "sql_disk_size" {
  type        = number
  description = "SQL Disk Size"
  default     = 80
}

variable "sql_disk_autoresize" {
  type        = bool
  description = "SQL Disk Auto Resize"
  default     = true
}

variable "sql_backup_enabled" {
  type        = bool
  description = "SQL Backup Enabled"
  default     = true
}

variable "sql_ckan_staging_user_name" {
  type        = string
  description = "SQL CKAN-Staging User Name"
  default     = "ckan_staging"
}

variable "sql_ckan_staging_user_password" {
  type        = string
  description = "SQL CKAN-Staging User Password"
}

variable "sql_ckan_staging_db_name" {
  type        = string
  description = "SQL CKAN-Staging DB Name"
  default     = "ckan_staging"
}

variable "sql_ckan_production_user_name" {
  type        = string
  description = "SQL CKAN-Production User Name"
  default     = "ckan_production"
}

variable "sql_ckan_production_user_password" {
  type        = string
  description = "SQL CKAN-Production User Password"
}

variable "sql_ckan_production_db_name" {
  type        = string
  description = "SQL CKAN-Production DB Name"
  default     = "ckan_production"
}

variable "sql_metabase_user_name" {
  type        = string
  description = "SQL Metabase User Name"
  default     = "metabase"
}
variable "sql_metabase_user_password" {
  type        = string
  description = "SQL Metabase User Password"
}

variable "sql_metabase_db_name" {
  type        = string
  description = "SQL Metabase DB Name"
  default     = "metabase"
}

variable "sql_prefect_user_name" {
  type        = string
  description = "SQL Prefect User Name"
  default     = "prefect"
}

variable "sql_prefect_user_password" {
  type        = string
  description = "SQL Prefect User Password"
}

variable "sql_prefect_db_name" {
  type        = string
  description = "SQL Prefect DB Name"
  default     = "prefect"
}

############
#
# GKE
#
############

variable "static_pool_machine_type" {
  type        = string
  description = "The machine type to use for the cluster's static pool."
  default     = "n1-standard-4"
}

variable "static_pool_node_count" {
  type        = number
  description = "The number of nodes to use for the static pool."
  default     = 2
}

variable "dynamic_pool_machine_type" {
  type        = string
  description = "The machine type to use for the cluster's dynamic pool."
  default     = "e2-medium"
}

variable "dynamic_pool_node_count" {
  type        = number
  description = "The default number of nodes to use for the dynamic pool."
  default     = 0
}

variable "dynamic_pool_node_min" {
  type        = number
  description = "The minimum number of nodes to use for the dynamic pool."
  default     = 0
}

variable "dynamic_pool_node_max" {
  type        = number
  description = "The maximum number of nodes to use for the dynamic pool."
  default     = 1
}

variable "dynamic_pool_node_preemptible" {
  type        = bool
  description = "Whether to use preemptible nodes for the dynamic pool."
  default     = true
}

############
#
# IAM
#
############
variable "gsa_cloudsql_account_id" {
  type        = string
  description = "Cloud SQL Account ID"
  default     = "gsa-cloudsql"
}

variable "role_iam_workload_identity_user" {
  type        = string
  description = "IAM workload identity user role."
  default     = "roles/iam.workloadIdentityUser"
}

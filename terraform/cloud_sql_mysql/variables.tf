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
# Cloud SQL MySQL
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

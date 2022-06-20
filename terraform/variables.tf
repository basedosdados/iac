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
  description = "The GCP region to use for the cluster."
  default     = "us-central1"
}

variable "zone" {
  description = "The GCP zone to use for the cluster."
  default     = "us-central1-c"
}

############
#
# GKE
#
############

variable "static_pool_machine_type" {
  description = "The machine type to use for the cluster's static pool."
  default     = "n1-standard-2"
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

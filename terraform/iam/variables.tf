#
# Multiple
#
variable "project_id" {
  description = "Project ID for the Cloud SQL project."
}

#
# Service accounts
#
variable "gsa_cloudsql_account_id" {
  description = "Cloud SQL Account ID"
}

#
# Bindings
#
variable "role_iam_workload_identity_user" {
  description = "IAM workload identity user role."
}

# Add IAM policy binding for Cloud SQL SA
resource "google_project_iam_member" "cloudsql" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${var.gsa-cloudsql.email}"
}

# Allow the Kubernetes service account to impersonate the Google
# service account by creating an IAM policy binding between the
# two. This binding allows the Kubernetes Service account to act
# as the Google service account.

# cloudsql
resource "google_service_account_iam_binding" "cloudsql" {
  service_account_id = var.gsa-cloudsql.name
  role               = var.role_iam_workload_identity_user

  members = [
    "serviceAccount:basedosdados-dev.svc.id.goog[cloud-sql-proxy/cloud-sql-access]",
    "serviceAccount:basedosdados-dev.svc.id.goog[cloud-sql-proxy/cloud-sql-proxy]",
  ]
}

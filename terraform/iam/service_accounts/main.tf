# GSA for Cloud SQL access
resource "google_service_account" "gsa-cloudsql" {
  account_id   = var.gsa_cloudsql_account_id
  display_name = var.gsa_cloudsql_account_id
}

module "service_accounts" {
  source                  = "./service_accounts"
  gsa_cloudsql_account_id = var.gsa_cloudsql_account_id
}

module "bindings" {
  source                          = "./bindings"
  depends_on                      = [module.service_accounts]
  project_id                      = var.project_id
  role_iam_workload_identity_user = var.role_iam_workload_identity_user
  gsa-cloudsql                    = module.service_accounts.gsa_cloudsql
}

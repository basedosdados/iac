# module "cloud_sql" {
#   source = "./cloud_sql"
#   region                            = var.region
#   sql_version                       = var.sql_version
#   sql_instance_tier                 = var.sql_instance_tier
#   sql_disk_size                     = var.sql_disk_size
#   sql_disk_autoresize               = var.sql_disk_autoresize
#   sql_backup_enabled                = var.sql_backup_enabled
#   sql_ckan_staging_user_name        = var.sql_ckan_staging_user_name
#   sql_ckan_staging_user_password    = var.sql_ckan_staging_user_password
#   sql_ckan_staging_db_name          = var.sql_ckan_staging_db_name
#   sql_ckan_production_user_name     = var.sql_ckan_production_user_name
#   sql_ckan_production_user_password = var.sql_ckan_production_user_password
#   sql_ckan_production_db_name       = var.sql_ckan_production_db_name
#   sql_metabase_user_name            = var.sql_metabase_user_name
#   sql_metabase_user_password        = var.sql_metabase_user_password
#   sql_metabase_db_name              = var.sql_metabase_db_name
#   sql_prefect_user_name             = var.sql_prefect_user_name
#   sql_prefect_user_password         = var.sql_prefect_user_password
#   sql_prefect_db_name               = var.sql_prefect_db_name
# }

module "gke" {
  source                        = "./gke"
  project_id                    = var.project_id
  region                        = var.region
  zone                          = var.zone
  static_pool_machine_type      = var.static_pool_machine_type
  static_pool_node_count        = var.static_pool_node_count
  dynamic_pool_machine_type     = var.dynamic_pool_machine_type
  dynamic_pool_node_count       = var.dynamic_pool_node_count
  dynamic_pool_node_min         = var.dynamic_pool_node_min
  dynamic_pool_node_max         = var.dynamic_pool_node_max
  dynamic_pool_node_preemptible = var.dynamic_pool_node_preemptible
}

module "iam" {
  source                          = "./iam"
  project_id                      = var.project_id
  role_iam_workload_identity_user = var.role_iam_workload_identity_user
  gsa_cloudsql_account_id         = var.gsa_cloudsql_account_id
}

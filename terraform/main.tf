terraform {
  required_providers {

    google = {
      source  = "hashicorp/google"
      version = "3.89.0"
    }
  }

  backend "gcs" {
    bucket = "terraform-data-basedosdados-dev"
    prefix = "basedosdados-dev"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

module "cloudsql" {
  source                      = "./cloud_sql"
  region                      = var.region
  zone                        = var.zone
  project_id                  = var.project_id
  sql_version                 = var.sql_version
  sql_instance_tier           = var.sql_instance_tier
  sql_deletion_protection     = var.sql_deletion_protection
  sql_disk_size               = var.sql_disk_size
  sql_disk_autoresize         = var.sql_disk_autoresize
  sql_disk_autoresize_limit   = var.sql_disk_autoresize_limit
  sql_backup_enabled          = var.sql_backup_enabled
  sql_backup_start_time       = var.sql_backup_start_time
  sql_backup_location         = var.sql_backup_location
  sql_db_max_connections      = var.sql_db_max_connections
  sql_id_server_user_name     = var.sql_id_server_user_name
  sql_id_server_user_password = var.sql_id_server_user_password
  sql_id_server_db_name       = var.sql_id_server_db_name
  sql_metabase_user_name      = var.sql_metabase_user_name
  sql_metabase_user_password  = var.sql_metabase_user_password
  sql_metabase_db_name        = var.sql_metabase_db_name
  sql_prefect_user_name       = var.sql_prefect_user_name
  sql_prefect_user_password   = var.sql_prefect_user_password
  sql_prefect_db_name         = var.sql_prefect_db_name
}

module "cloudsql_mysql" {
  source                     = "./cloud_sql_mysql"
  region                     = var.region
  zone                       = var.zone
  project_id                 = var.project_id
  sql_version                = var.sql_version_mysql
  sql_instance_tier          = var.sql_instance_tier
  sql_deletion_protection    = var.sql_deletion_protection
  sql_disk_size              = var.sql_disk_size
  sql_disk_autoresize        = var.sql_disk_autoresize
  sql_disk_autoresize_limit  = var.sql_disk_autoresize_limit
  sql_backup_enabled         = var.sql_backup_enabled
  sql_backup_start_time      = var.sql_backup_start_time
  sql_backup_location        = var.sql_backup_location
  sql_db_max_connections     = var.sql_db_max_connections
  sql_passbolt_user_name     = var.sql_passbolt_user_name
  sql_passbolt_user_password = var.sql_passbolt_user_password
  sql_passbolt_db_name       = var.sql_passbolt_db_name
}

module "cloud_storage" {
  source      = "./cloud_storage"
  bucket_name = var.bucket_name
}

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

############################################################################
# Common
############################################################################
project_id = "basedosdados-dev"
region     = "us-central1"
zone       = "us-central1-c"
############################################################################
# Cloud SQL
############################################################################
sql_version                       = "POSTGRES_13"
sql_instance_tier                 = "db-f1-micro"
sql_disk_size                     = 30
sql_disk_autoresize               = true
sql_backup_enabled                = true
sql_backup_start_time             = "00:00"
sql_ckan_production_user_name     = "ckan_production"
sql_ckan_production_user_password = "ckan_production"
sql_ckan_production_db_name       = "ckan_production"
sql_ckan_staging_user_name        = "ckan_staging"
sql_ckan_staging_user_password    = "ckan_staging"
sql_ckan_staging_db_name          = "ckan_staging"
sql_metabase_user_name            = "metabase"
sql_metabase_user_password        = "metabase"
sql_metabase_db_name              = "metabase"
sql_prefect_user_name             = "prefect"
sql_prefect_user_password         = "prefect"
sql_prefect_db_name               = "prefect"
############################################################################
# GKE
############################################################################
static_pool_machine_type      = "n1-standard-4"
static_pool_node_count        = 2
dynamic_pool_machine_type     = "e2-medium"
dynamic_pool_node_count       = 0
dynamic_pool_node_min         = 0
dynamic_pool_node_max         = 1
dynamic_pool_node_preemptible = true
############################################################################
# IAM
############################################################################
gsa_cloudsql_account_id         = "gsa-cloudsql"
role_iam_workload_identity_user = "roles/iam.workloadIdentityUser"

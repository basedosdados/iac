############################################################################
# Common
############################################################################
project_id = "basedosdados-dev"
region     = "us-central1"
zone       = "us-central1-c"
############################################################################
# Cloud SQL
############################################################################
sql_version               = "POSTGRES_13"
sql_instance_tier         = "db-f1-micro"
sql_disk_size             = 30
sql_disk_autoresize       = true
sql_disk_autoresize_limit = 200
sql_backup_enabled        = true
sql_backup_start_time     = "00:00"
sql_db_max_connections    = 500
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
############################################################################
# Sensitive data that are inputed by CI/CD pipeline
############################################################################
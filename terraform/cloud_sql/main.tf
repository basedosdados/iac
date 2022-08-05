resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "main" {
  name                = "${var.project_id}-${var.sql_version}-${random_id.db_name_suffix.hex}"
  region              = var.region
  database_version    = var.sql_version
  deletion_protection = false

  settings {
    tier            = var.sql_instance_tier
    disk_size       = var.sql_disk_size
    disk_autoresize = var.sql_disk_autoresize

    backup_configuration {
      enabled    = var.sql_backup_enabled
      start_time = var.sql_backup_start_time
    }

    database_flags {
      name  = "max_connections"
      value = "500"
    }
  }
}

resource "google_sql_user" "ckan_production" {
  name     = var.sql_ckan_production_user_name
  instance = google_sql_database_instance.main.name
  password = var.sql_ckan_production_user_password
}

resource "google_sql_database" "ckan_production" {
  name     = var.sql_ckan_production_db_name
  instance = google_sql_database_instance.main.name
}

resource "google_sql_user" "ckan_staging" {
  name     = var.sql_ckan_staging_user_name
  instance = google_sql_database_instance.main.name
  password = var.sql_ckan_staging_user_password
}

resource "google_sql_database" "ckan_staging" {
  name     = var.sql_ckan_staging_db_name
  instance = google_sql_database_instance.main.name
}

resource "google_sql_database" "id_basedosdados" {
  name     = var.sql_id_basedosdados_db_name
  instance = google_sql_database_instance.main.name
}

resource "google_sql_user" "id_basedosdados" {
  name     = var.sql_id_basedosdados_user_name
  instance = google_sql_database_instance.main.name
  password = var.sql_ckan_production_user_password
}

resource "google_sql_user" "metabase" {
  name     = var.sql_metabase_user_name
  instance = google_sql_database_instance.main.name
  password = var.sql_metabase_user_password
}

resource "google_sql_database" "metabase" {
  name     = var.sql_metabase_db_name
  instance = google_sql_database_instance.main.name
}

resource "google_sql_user" "prefect" {
  name     = var.sql_prefect_user_name
  instance = google_sql_database_instance.main.name
  password = var.sql_prefect_user_password
}

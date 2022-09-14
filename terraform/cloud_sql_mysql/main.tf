resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "main" {
  name                = "${var.project_id}-${random_id.db_name_suffix.hex}"
  region              = var.region
  database_version    = var.sql_version
  deletion_protection = var.sql_deletion_protection

  settings {
    tier                  = var.sql_instance_tier
    disk_size             = var.sql_disk_size
    disk_autoresize       = var.sql_disk_autoresize
    disk_autoresize_limit = var.sql_disk_autoresize_limit

    backup_configuration {
      enabled    = var.sql_backup_enabled
      start_time = var.sql_backup_start_time
      location   = var.sql_backup_location
    }

    database_flags {
      name  = "max_connections"
      value = var.sql_db_max_connections
    }

    location_preference {
      zone = var.zone
    }
  }
}

resource "google_sql_user" "passbolt" {
  name     = var.sql_passbolt_user_name
  instance = google_sql_database_instance.main.name
  password = var.sql_passbolt_user_password
}

resource "google_sql_database" "passbolt" {
  name     = var.sql_passbolt_db_name
  instance = google_sql_database_instance.main.name
}

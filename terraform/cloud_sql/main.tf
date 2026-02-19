# ...........................................................................
# Create Random Data
# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id
# ...........................................................................
resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "random_password" "api_development_db_password" {
  length           = 22
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_password" "api_staging_db_password" {
  length           = 22
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_password" "api_db_password" {
  length           = 22
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_password" "chatbot_staging_db_password" {
  length           = 22
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_password" "chatbot_db_password" {
  length           = 22
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# ...........................................................................
# Write data to Secret Manager
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret
# ...........................................................................
resource "google_secret_manager_secret" "api_development_db_password" {
  secret_id = "api-development-db-password"

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "api_development_db_password" {
  secret      = google_secret_manager_secret.api_development_db_password.id
  secret_data = random_password.api_development_db_password.result
}

resource "google_secret_manager_secret" "api_staging_db_password" {
  secret_id = "api-staging-db-password"

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "api_staging_db_password" {
  secret      = google_secret_manager_secret.api_staging_db_password.id
  secret_data = random_password.api_staging_db_password.result
}

resource "google_secret_manager_secret" "api_db_password" {
  secret_id = "api-db-password"

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "api_db_password" {
  secret      = google_secret_manager_secret.api_db_password.id
  secret_data = random_password.api_db_password.result
}

resource "google_secret_manager_secret" "chatbot_staging_db_password" {
  secret_id = "chatbot-staging-db-password"

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "chatbot_staging_db_password" {
  secret      = google_secret_manager_secret.chatbot_staging_db_password.id
  secret_data = random_password.chatbot_staging_db_password.result
}

resource "google_secret_manager_secret" "chatbot_db_password" {
  secret_id = "chatbot-db-password"

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "chatbot_db_password" {
  secret      = google_secret_manager_secret.chatbot_db_password.id
  secret_data = random_password.chatbot_db_password.result
}

# ...........................................................................
# Create Cloud SQL
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance
# ...........................................................................
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

# ...........................................................................
# Create Cloud SQL Databases and Users
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_user
# ...........................................................................
resource "google_sql_database" "api" {
  name     = "api"
  instance = google_sql_database_instance.main.name
}

resource "google_sql_user" "api_prod" {
  name     = "api"
  instance = google_sql_database_instance.main.name
  password = random_password.api_db_password.result
}

resource "google_sql_database" "api_staging" {
  name     = var.sql_api_staging_db_name
  instance = google_sql_database_instance.main.name
}

resource "google_sql_user" "api_staging" {
  name     = var.sql_api_staging_user_name
  instance = google_sql_database_instance.main.name
  password = random_password.api_staging_db_password.result
}

resource "google_sql_database" "chatbot" {
  name     = "chatbot"
  instance = google_sql_database_instance.main.name
}

resource "google_sql_user" "chatbot" {
  name     = "chatbot"
  instance = google_sql_database_instance.main.name
  password = random_password.chatbot_db_password.result
}

resource "google_sql_database" "chatbot_staging" {
  name     = "chatbot_staging"
  instance = google_sql_database_instance.main.name
}

resource "google_sql_user" "chatbot_staging" {
  name     = "chatbot_staging"
  instance = google_sql_database_instance.main.name
  password = random_password.chatbot_staging_db_password.result
}

resource "google_sql_database" "api_development" {
  name     = var.sql_api_development_db_name
  instance = google_sql_database_instance.main.name
}

resource "google_sql_user" "api_development" {
  name     = var.sql_api_development_user_name
  instance = google_sql_database_instance.main.name
  password = random_password.api_development_db_password.result
}

resource "google_sql_database" "id_server" {
  name     = var.sql_id_server_db_name
  instance = google_sql_database_instance.main.name
}

resource "google_sql_user" "id_server" {
  name     = var.sql_id_server_user_name
  instance = google_sql_database_instance.main.name
  password = var.sql_id_server_user_password
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

resource "google_sql_database" "prefect" {
  name     = var.sql_prefect_db_name
  instance = google_sql_database_instance.main.name
}

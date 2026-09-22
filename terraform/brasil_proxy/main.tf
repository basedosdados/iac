# ...........................................................................
# Service account dedicada — sem roles de projeto, a VM só roda o Squid.
# ...........................................................................
resource "google_service_account" "gsa-brasil-proxy" {
  account_id   = "gsa-brasil-proxy"
  display_name = "gsa-brasil-proxy"
}

# ...........................................................................
# Credencial do proxy (usuário fixo, senha aleatória) — mesmo padrão do
# módulo cloud_sql: random_password + Secret Manager.
# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password
# ...........................................................................
resource "random_password" "brasil_proxy_password" {
  length           = 24
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "google_secret_manager_secret" "brasil_proxy_password" {
  secret_id = "brasil-proxy-password"

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "brasil_proxy_password" {
  secret      = google_secret_manager_secret.brasil_proxy_password.id
  secret_data = random_password.brasil_proxy_password.result
}

# ...........................................................................
# IP externo estático — pra o endereço do proxy não mudar entre
# reboots/recriações da VM.
# ...........................................................................
resource "google_compute_address" "brasil_proxy_static_ip" {
  name    = "brasil-proxy-static-ip"
  region  = var.region
  project = var.project_id
}

# ...........................................................................
# Firewall — libera a porta do Squid. Sem allowlist de IP confiável hoje
# (não há Cloud NAT gerenciado por Terraform em lugar nenhum, então não dá
# pra garantir uma origem estática pro tráfego do GKE); a autenticação do
# Squid (usuário/senha) é o controle de acesso principal, não o firewall.
# ...........................................................................
resource "google_compute_firewall" "allow_brasil_proxy" {
  name    = "allow-brasil-proxy"
  network = "default"
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = [tostring(var.proxy_port)]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["brasil-proxy"]
}

# ...........................................................................
# A VM em si — pequena, só roda o Squid. metadata_startup_script instala e
# configura o proxy no primeiro boot (ver startup-script.sh.tpl).
# ...........................................................................
resource "google_compute_instance" "brasil_proxy" {
  name         = "brasil-proxy"
  machine_type = var.machine_type
  zone         = var.zone
  project      = var.project_id
  tags         = ["brasil-proxy"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.brasil_proxy_static_ip.address
    }
  }

  service_account {
    email  = google_service_account.gsa-brasil-proxy.email
    scopes = ["logging-write", "monitoring-write"]
  }

  metadata_startup_script = templatefile("${path.module}/startup-script.sh.tpl", {
    proxy_username = var.proxy_username
    proxy_password = random_password.brasil_proxy_password.result
    proxy_port     = var.proxy_port
  })
}

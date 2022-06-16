# Configure the Google Cloud provider
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.89.0"
    }
  }
}

data "terraform_remote_state" "project_id" {
  backend   = "gcs"
  workspace = terraform.workspace

  config = {
    bucket = var.bucket_name
    prefix = "terraform-project"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
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

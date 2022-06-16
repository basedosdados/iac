resource "google_container_cluster" "primary" {
  name                     = "${var.project_id}-gke"
  location                 = var.zone
  remove_default_node_pool = true
  initial_node_count       = 1
  workload_identity_config {
    identity_namespace = "${var.project_id}.svc.id.goog"
  }
  node_config {
    preemptible = true
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }
}

resource "google_container_node_pool" "prod_static_node_pool" {
  name       = "${var.project_id}-pool-static"
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = var.static_pool_node_count
  node_config {
    machine_type = var.static_pool_machine_type
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }
}

resource "google_container_node_pool" "prod_autoscale_node_pool" {
  name       = "${var.project_id}-pool-dynamic"
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = var.dynamic_pool_node_count

  # autoscaling {
  #   min_node_count = var.dynamic_pool_node_min
  #   max_node_count = var.dynamic_pool_node_max
  # }

  node_config {
    preemptible  = var.dynamic_pool_node_preemptible
    machine_type = var.dynamic_pool_machine_type
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }
}

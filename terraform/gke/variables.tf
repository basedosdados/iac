variable "project_id" {
  description = "The GCP project ID to use for the cluster."
}

variable "region" {
  description = "The GCP region to use for the cluster."
}

variable "zone" {
  description = "The GCP zone to use for the cluster."
}

variable "static_pool_machine_type" {
  description = "The machine type to use for the cluster's static pool."
}

variable "static_pool_node_count" {
  description = "The number of nodes to use for the static pool."
}

variable "dynamic_pool_machine_type" {
  description = "The machine type to use for the cluster's dynamic pool."
}

variable "dynamic_pool_node_count" {
  description = "The default number of nodes to use for the dynamic pool."
}

variable "dynamic_pool_node_min" {
  description = "The minimum number of nodes to use for the dynamic pool."
}

variable "dynamic_pool_node_max" {
  description = "The maximum number of nodes to use for the dynamic pool."
}

variable "dynamic_pool_node_preemptible" {
  description = "Whether to use preemptible nodes for the dynamic pool."
}

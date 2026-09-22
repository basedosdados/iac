variable "project_id" {
  description = "The GCP project ID to use."
}

variable "region" {
  description = "The GCP region for the proxy VM (southamerica-east1)."
}

variable "zone" {
  description = "The GCP zone for the proxy VM (e.g. southamerica-east1-a)."
}

variable "machine_type" {
  description = "Machine type for the proxy VM."
  default     = "e2-small"
}

variable "proxy_port" {
  description = "Port the Squid proxy listens on."
  type        = number
  default     = 3128
}

variable "proxy_username" {
  description = "Basic auth username Squid requires before forwarding traffic."
  default     = "brasil-proxy"
}

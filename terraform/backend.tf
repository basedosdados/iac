# Configure the GCP tfstate file location
terraform {
  backend "gcs" {
    bucket = "terraform-data-basedosdados-dev"
    prefix = "basedosdados-dev"
  }
}

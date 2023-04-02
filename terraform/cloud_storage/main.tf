# ...........................................................................
# Cloud Storage Bucket
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket
# ...........................................................................
resource "google_storage_bucket" "website_images" {
  name                        = var.bucket_name
  location                    = var.bucket_location
  storage_class               = var.bucket_storage_class
  force_destroy               = var.bucket_force_destroy
  uniform_bucket_level_access = var.bucket_uniform_bucket_level_access

  versioning {
    enabled = var.bucket_versioning
  }
}

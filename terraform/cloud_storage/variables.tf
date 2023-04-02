# ...........................................................................
# Cloud Storage Module
# ...........................................................................
variable "bucket_name" {
  type        = string
  description = "The name of the bucket."
}

variable "bucket_location" {
  type        = string
  description = "The location of the bucket."
  default     = "US"
}

variable "bucket_storage_class" {
  type        = string
  description = "The storage class of the bucket."
  default     = "STANDARD"
}

variable "bucket_force_destroy" {
  type        = bool
  description = "Whether to delete all objects from the bucket so that the bucket can be destroyed without error."
  default     = false
}

variable "bucket_uniform_bucket_level_access" {
  type        = bool
  description = "Whether to enable Uniform Bucket-Level Access for the bucket."
  default     = true
}

variable "bucket_versioning" {
  type        = bool
  description = "Whether to enable versioning for the bucket."
  default     = true
}

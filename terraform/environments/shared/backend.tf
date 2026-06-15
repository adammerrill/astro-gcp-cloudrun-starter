# backend.tf — GCS backend configured for the shared environment.
# Note: You must run scripts/bootstrap.sh first to create the GCS bucket before initializing this.

terraform {
  backend "gcs" {
    bucket = "mortru-tf-state"
    prefix = "shared"
  }
}

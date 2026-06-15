terraform {
  backend "gcs" {
    bucket = "mortru-tf-state"
    prefix = "dev"
  }
}

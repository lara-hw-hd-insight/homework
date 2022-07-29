terraform {
  backend "gcs" {
      bucket = "backend-for-tf"
      prefix = "env/dev"
  }
}
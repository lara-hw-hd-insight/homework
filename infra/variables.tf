variable "project_name" {
  type        = string
  description = "Name of GCP project"
  default = "demo-project"
}

variable "service_account_name" {
  type        = string
  description = "Name of GCP service account"
  default = "demo_sa"
}

variable "regions" {
  type        = list(string)
  description = "Regions list"
  default = ["us-east1", "us-central1"]
}

variable "vm_names_append" {
  type        = list(string)
  description = "VM names appended parts list"
  default = ["us-east1", "us-central1"]
}

variable "bucket_name" {
  type        = string
  description = "Name of bucker"
  default = "test-bucket"
}

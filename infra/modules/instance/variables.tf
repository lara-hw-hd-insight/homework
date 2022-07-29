  variable "os_image" {
  type        = string
  description = "OS to use"
  default = "debian-cloud/debian-9"
}

variable "machine_type" {
  type        = string
  description = "VM machine type"
  default = "e2-micro"
}

variable "project_id" {
  type        = string
  description = "ID of GCP project"  
}

variable "name" {
  type        = string
  description = "VM name"  
}

variable "subnetwork" {
  type        = string
  description = "Self-link of subnet to use"  
}

variable "service_account_email" {
  type        = string
  description = "service account email"  
}
  
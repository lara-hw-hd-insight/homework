# we'll need self links on gcp subnets (of default VPC) for the regions
data "google_compute_subnetwork" "us-east1" {
  name   = "default"
  region = "us-east1"
}
data "google_compute_subnetwork" "us-central1" {
  name   = "default"
  region = "us-central1"
}


locals {
    required_apis = [
        "compute.googleapis.com",
        "storage.googleapis.com"
    ]
    subnets = [
        data.google_compute_subnetwork.us-east1.self_link,
        data.google_compute_subnetwork.us-central1.self_link
    ]
}

# get project id
data "google_projects" "my-projects" {
  filter = "name:${var.project_name}"
}
data "google_project" "project_to_use" {
  project_id = data.google_projects.my-projects.projects[0].project_id
}

# enable required APIs
resource "google_project_service" "project_apis" {
    for_each = toset(local.required_apis)

    project = data.google_project.project_to_use.project_id
    service = each.key
    disable_on_destroy = false
}

# !!!! we would create a service account in terraform, but we would get its email (and some other info) back from GCP as requested
# this is of course not a good approach but acceptable as a part of technical challenge for interview
resource "google_service_account" "service_account"{
    project = data.google_project.project_to_use.project_id
    display_name = var.service_account_name
    account_id = var.service_account_name
}

data "google_service_account" "my_sa" {
  account_id = var.service_account_name
    depends_on = [
    google_service_account.service_account
  ]
}

# We are explicitly prohibited from using region/zone in the VM configuration
# but GCP instance requires zone to be created
# so let's use this trick with setting provider zone and then creating vm
provider "google" {  
  zone = "${var.regions[0]}-b"
  alias = "first_region"
}

provider "google" {  
  zone = "${var.regions[1]}-a"
  alias = "second_region"
}

# creating VMs with a custom module
module "vm_instance1" {
  source                = "./modules/instance"
  providers = {
      google = google.first_region
  }
  os_image              = "debian-cloud/debian-9"  
  machine_type          = "e2-micro"   
  project_id            = data.google_project.project_to_use.project_id  
  name                  = "${var.project_name}-${var.vm_names_append[0]}"
  subnetwork            = local.subnets[0]
  service_account_email = data.google_service_account.my_sa.email

  depends_on = [
    google_service_account.service_account
  ]
}

# creating VMs with a custom module
module "vm_instance2" {
  source                = "./modules/instance"
  providers = {
    google = google.second_region
  }
  os_image              = "debian-cloud/debian-9"  
  machine_type          = "e2-micro"   
  project_id            = data.google_project.project_to_use.project_id  
  name                  = "${var.project_name}-${var.vm_names_append[1]}"
  subnetwork            = local.subnets[1]
  service_account_email = data.google_service_account.my_sa.email
  depends_on = [
    google_service_account.service_account
  ]
}

# random symbols to make bucket name unique
resource "random_id" "default" {
  byte_length = 8
}

# a gcp bucket with depends on vm1
resource "google_storage_bucket" "bucket" {
  name          = "${var.bucket_name}-${random_id.default.dec}" # make unique bucket name via random symbols
  location      = "US"
  depends_on = [
    module.vm_instance1
  ]  
}
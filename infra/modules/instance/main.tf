resource "google_compute_instance" "default" {
  name         = var.name
  machine_type = var.machine_type
  project      = var.project_id

  boot_disk {
    initialize_params {
      image = var.os_image
    }
  }

  network_interface {    
    subnetwork = var.subnetwork

    access_config {
      // Ephemeral public IP
    }
  }
  
  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }
}
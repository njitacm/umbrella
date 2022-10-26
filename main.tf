terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.27.0"
    }
  }
}

provider "google" {
  credentials = file(var.creds)
  project     = var.project
  region      = var.region
  zone        = var.zone
}

# Enable Google Compute Service
resource "google_project_service" "computeAPI" {
    project = var.project
    service = "compute.googleapis.com"
    timeouts {
        create = "30m"
        update = "40m"
    }
    disable_dependent_services = true
    disable_on_destroy = false
}

resource "google_compute_network" "vpc_network" {
  name                    = "infra"
  auto_create_subnetworks = false
}

#Create Compute Instance
resource "google_compute_instance" "vm_instance"{
  name          = "terraform-instance"
  machine_type  = "f1-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    #A default network created for GCP projects
    network = "${google_compute_network.vpc_network.self_link}"
    access_config {
    }
  }

}

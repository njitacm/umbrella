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
resource "google_compute_network" "vpc" {
  name                    = "${var.name}-vpc"
  auto_create_subnetworks = "false"
  routing_mode            = "GLOBAL"
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.name}-subnet"
  ip_cidr_range = var.vpc_cidr
  network       = google_compute_network.vpc.name
  region        = var.region
}
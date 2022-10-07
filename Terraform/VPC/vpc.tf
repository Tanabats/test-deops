

variable "region" {
  default     = "asia-southeast1"

}
variable "project_id" {
  default     = "aerial-velocity-364508"

}
provider "google" {
  project = var.project_id
  region  = var.region
}

# VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.project_id}-vpc"
  auto_create_subnetworks = "false"
}

# Subnet
resource "google_compute_subnetwork" "subnet-public" {
  name          = "${var.project_id}-subnet-public"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.10.0.0/24"
}
# Subnet
resource "google_compute_subnetwork" "subnet-private" {
  name          = "${var.project_id}-subnet-private"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.11.0.0/24"
}

resource "google_compute_subnetwork" "proxy_subnet" {
  project       = var.project_id
  name          = "${var.project_id}-ilb-proxy-subnet"
  provider      = google-beta
  ip_cidr_range = "10.12.0.0/24"
  region        = var.region
  purpose       = "REGIONAL_MANAGED_PROXY"
  role          = "ACTIVE"
  network       = google_compute_network.vpc.name
}

### allow traffic from proxy internal lb to pod in cluster
resource "google_compute_firewall" "allow-proxy-connection" {
  name    = "${var.project_id}-ilb-firewall"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["8000","9090"]
  }
  source_ranges = ["10.12.0.0/24"]
}


### allow only vm and cluster1 to cluster2
resource "google_compute_firewall" "allow-monitor-cluster" {
  name    = "${var.project_id}-allow-monitor-cluster-firewall"
  network = google_compute_network.vpc.name
  priority = "100"
  direction = "EGRESS"
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  target_tags = ["monitor","cluster1"]
  destination_ranges = ["10.11.0.0/24"]
}


### deny all traffic to cluster2
resource "google_compute_firewall" "deny-to-ilb-cluster" {
  name    = "${var.project_id}-deny-to-ilb-cluster-firewall"
  network = google_compute_network.vpc.name

  priority = "200"
  direction = "EGRESS"
  deny {
    protocol = "all"
    ports    = []
  }
  destination_ranges = ["10.11.0.0/24"]
}
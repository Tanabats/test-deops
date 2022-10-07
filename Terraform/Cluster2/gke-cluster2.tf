
variable "region" {
  default     = "asia-southeast1"

}
variable "project_id" {
  default     = "aerial-velocity-364508"

}
   
variable "gke_num_nodes" {
  default     = 1
  description = "number of gke nodes"
}
provider "google" {
  project = var.project_id
  region  = var.region
}

# GKE cluster
resource "google_container_cluster" "primary-2" {
  name     = "${var.project_id}-gke-2"
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = "${var.project_id}-vpc"
  subnetwork = "${var.project_id}-subnet-private"
  # private_cluster_config  {
  # enable_private_nodes = true
  # enable_private_endpoint = false
  # }
}

# Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes-2" {
  name       = "${google_container_cluster.primary-2.name}-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary-2.name
  node_count = var.gke_num_nodes
  node_locations = ["asia-southeast1-a"]
  node_config {
    preemptible  = true
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.project_id
    }

    # preemptible  = true
    machine_type = "e2-medium"
    tags         = ["cluster2","gke-node", "${var.project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

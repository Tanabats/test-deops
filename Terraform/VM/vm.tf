provider "google" {
  project = var.project_id
  region  = var.region
}
variable "region" {
  default     = "asia-southeast1"

}
variable "project_id" {
  default     = "aerial-velocity-364508"

}
resource "google_compute_instance" "monitor" {
  name         = "monitor"
  machine_type = "e2-medium"
  zone         = "asia-southeast1-a"

  tags = ["monitor"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }


  network_interface {
  network    = "${var.project_id}-vpc"
  subnetwork = "${var.project_id}-subnet-private"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata_startup_script = <<-EOF
     apt-get install -y apt-transport-https
     apt-get install -y software-properties-common wget
     wget -q -O /usr/share/keyrings/grafana.key https://packages.grafana.com/gpg.key
    echo 'deb [signed-by=/usr/share/keyrings/grafana.key] https://packages.grafana.com/oss/deb stable main' | sudo tee -a /etc/apt/sources.list.d/grafana.list
     apt-get update
     apt-get install -y openjdk-11-jdk
     apt-get install grafana -y
     systemctl daemon-reload
     systemctl start grafana-server
     systemctl enable grafana-server.service
     curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
     echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list &gt; /dev/null
     apt update
     apt install -y jenkins
     systemctl enable --now jenkins
     cat /var/lib/jenkins/secrets/initialAdminPassword >> ./jenkin_pass.txt
     apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
     mkdir -p /etc/apt/keyrings
     curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
     echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
     apt-get update
     apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
     usermod -aG docker jenkins
    EOF
    

#   service_account {
#     # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
#     email  = google_service_account.default.email
#     scopes = ["cloud-platform"]
#   }
}
resource "google_compute_firewall" "allow-access-monitor" {
  name    = "${var.project_id}-monitor-firewall"
  network = "${var.project_id}-vpc"

  allow {
    protocol = "tcp"
    ports    = ["3000","22","8080"]
  }
  target_tags = ["monitor"]
  source_ranges = ["0.0.0.0/0"]
  
}
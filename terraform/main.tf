resource "google_compute_network" "vpc_network" {
  name                    = "${var.project_name}-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_subnet" {
  name          = "${var.project_name}-subnet"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

resource "google_dns_managed_zone" "dns_private_zone" {
  name        = "${var.project_name}-private-zone"
  dns_name    = "${var.project_name}.example.com."
  description = "Private DNS zone for ${var.project_name}"

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = google_compute_network.vpc_network.id
    }
  }
}

resource "google_compute_firewall" "compute_ssh_firewall" {
  name    = "${var.project_name}-ssh-firewall"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["iap-tunnel"]
}

resource "google_compute_firewall" "compute_internal_firewall" {
  name    = "${var.project_name}-internal-firewall"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_tags = ["k8s"]
  target_tags = ["k8s"]
}

# GKE 
resource "google_container_cluster" "gke_cluster" {
  name     = "${var.project_name}-cluster"
  location = var.region
  
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc_network.name
  subnetwork = google_compute_subnetwork.vpc_subnet.name
}

# Separately Managed Node Pool
resource "google_container_node_pool" "gke_nodepool" {
  name       = "${var.project_name}-pool"
  location   = var.region
  cluster    = google_container_cluster.gke_cluster.name
  node_count = var.k8s_nodes["count"]

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      project = var.project_name
    }

    # preemptible  = true
    machine_type = var.k8s_nodes["type"]
    tags         = ["gke-node", "${var.project_name}"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}
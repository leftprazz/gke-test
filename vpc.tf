resource "google_compute_network" "gke-test" {
    name                            = var.network.name
    routing_mode                    = "REGIONAL"
    auto_create_subnetworks         = false
    mtu                             = 1460
    delete_default_routes_on_create = false
    
    depends_on = [
        google_project_service.gke-test["compute"]
        ]
}

resource "google_compute_subnetwork" "gke-test" {
  name                     = var.network.subnetwork_name
  ip_cidr_range            = var.network.nodes_cidr_range
  region                   = var.region
  network                  = google_compute_network.gke-test.id
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "${var.network.subnetwork_name}-pod-range"
    ip_cidr_range = var.network.pods_cidr_range
  }
  secondary_ip_range {
    range_name    = "${var.network.subnetwork_name}-service-range"
    ip_cidr_range = var.network.services_cidr_range
  }

  lifecycle {
    ignore_changes = [
      secondary_ip_range,
      ip_cidr_range,
    ]
  }
}


resource "google_compute_firewall" "gke-test-allow-ssh" {
    name    = "gke-test-allow-ssh"
    network = google_compute_network.gke-test.name

    allow {
        protocol = "tcp"
        ports = ["22"] 
    }
    source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "gke-test-allow-http" {
    name    = "gke-test-allow-http"
    network = google_compute_network.gke-test.name

    allow {
        protocol = "tcp"
        ports = ["80"] 
    }
    source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "gke-test-allow-https" {
    name    = "gke-test-allow-https"
    network = google_compute_network.gke-test.name

    allow {
        protocol = "tcp"
        ports = ["443"] 
    }
    source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "gke-test-allow-app" {
    name    = "gke-test-allow-app"
    network = google_compute_network.gke-test.name

    allow {
        protocol = "tcp"
        ports = ["8081-8082"] 
    }
    source_ranges = ["0.0.0.0/0"]
}
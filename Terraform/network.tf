#vpc
resource "google_compute_network" "kareem-vpc" {
  name                    = "kareem-vpc"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

#management subnet for vm
resource "google_compute_subnetwork" "management_subnet" {
  name          = "management-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = "us-central1"
  network       = google_compute_network.kareem-vpc.id
}

#restricted subnet for GKE
resource "google_compute_subnetwork" "restricted_subnet" {
  name          = "restricted-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.kareem-vpc.id
  private_ip_google_access = true
}

#router
resource "google_compute_router" "router" {
  name    = "router"
  region  = google_compute_subnetwork.management_subnet.region
  network = google_compute_network.kareem-vpc.id
}

#nat-gateway
resource "google_compute_router_nat" "nat-gw" {
  name                               = "my-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.management_subnet.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

#firewall-IAP
resource "google_compute_firewall" "fw-iap" {
  name    = "fw-iap"
  network = google_compute_network.kareem-vpc.id
  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }
  direction     = "INGRESS"
  source_ranges = ["35.235.240.0/20"]
}


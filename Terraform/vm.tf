#private VM
resource "google_compute_instance" "private-vm" {
  name         = "private-vm"
  machine_type = "e2-micro"
  zone         = "us-central1-a"
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }
  #connect it with management subnet
  network_interface {
    network = google_compute_network.kareem-vpc.id
    subnetwork = google_compute_subnetwork.management_subnet.id
  }

}

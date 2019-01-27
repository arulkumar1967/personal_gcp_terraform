resource "google_compute_instance" "compute_instance" {
    count = "${var.deploy_gitlab ? 1 : 0}"
    name = "${var.prefix}${var.instance_name}"
    machine_type = "${var.machine_type}"
    zone = "${var.zone}"

    tags = ["gitlab"]

    connection {
        type = "ssh"
        user = "ubuntu"
        agent = "false"
        private_key = "${file("${var.ssh_key}")}"
    }

    boot_disk {
        initialize_params {
            image = "${var.image}"
          }
    }

    attached_disk {
        source = "${var.data_volume}"            
        device_name = "gitlab_data"
    }

    network_interface {
        network = "${var.network}"
        access_config {
           // nat_ip = "${google_compute_address.external_ip.address}"
        }
    }

    metadata {
        sshKeys = "ubuntu:${file("${var.ssh_key}.pub")}"
    }

    service_account {       
        email = "$var.service_account_email}"
        scopes = ["cloud-platform"]
    }    
}

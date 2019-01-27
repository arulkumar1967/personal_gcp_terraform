
resource "google_compute_instance" "gitlab-ci-runner" {
    #count = "${var.runner_count}"
    name = "${var.prefix}gitlab-ci-runner-vm"
    machine_type = "${var.runner_machine_type}"
    zone = "${var.zone}"

    tags = ["gitlab-ci-runner"]

    network_interface {
        network = "${var.network}"
        access_config {
          // Ephemeral IP
        }
    }

    metadata {
        sshKeys = "ubuntu:${file("${var.ssh_key}.pub")}"
    }

    connection {
        type = "ssh"
        user = "ubuntu"
        agent = "false"
        private_key = "${file("${var.ssh_key}")}"
    }

    boot_disk {
        initialize_params {
            image = "${var.image}"
            size = "${var.runner_disk_size}"
        }
    }

    provisioner "file" {
        source = "${path.module}/bootstrap_runner"
        destination = "/tmp/bootstrap_runner"
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/bootstrap_runner",
            "sudo /tmp/bootstrap_runner ${var.instance_name} ${var.runner_host} ${var.runner_token} ${var.runner_image}}"
        ]
    }

    provisioner "remote-exec" {
      when = "destroy"
      inline = [
        "sudo gitlab-ci-multi-runner unregister --name ${var.instance_name}"
      ]

    }

}

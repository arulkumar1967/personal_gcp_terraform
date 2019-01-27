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

    provisioner "file" {
        content = "${data.template_file.gitlab.rendered}"
        destination = "/tmp/gitlab.rb.append"
    }

    provisioner "file" {
        source = "${path.module}/templates/gitlab.rb.append"
        destination = "/tmp/gitlab.rb"
    }

    provisioner "file" {
        source = "${path.module}/bootstrap"
        destination = "/tmp/bootstrap"
    }

    provisioner "file" {
        source = "${var.ssl_key}"
        destination = "/tmp/ssl_key"
    }

    provisioner "file" {
        source = "${var.ssl_certificate}"
        destination = "/tmp/ssl_certificate"
    }

    provisioner "remote-exec" {
        inline = [
            "cat /tmp/gitlab.rb.append >> /tmp/gitlab.rb",
            "chmod +x /tmp/bootstrap",
            "sudo /tmp/bootstrap ${var.dns_name}"
        ]
    }  

}


resource "random_id" "initial_root_password" {
    byte_length = 15
}

resource "random_id" "runner_token" {
    byte_length = 15
}

data "template_file" "gitlab" {
    template = "${file("${path.module}/templates/gitlab.rb.append")}"

    vars {
        initial_root_password = "${var.initial_root_password != "GENERATE" ? var.initial_root_password : format("%s", random_id.initial_root_password.hex)}"
        runner_token = "${var.runner_token != "GENERATE" ? var.runner_token : format("%s", random_id.runner_token.hex)}"
    }
}

data "template_file" "runner_host" {
    template = "${runner_host == "GENERATE" ? generated_host : runner_host}"
    vars {
      runner_host = "${var.runner_host}"
      #generated_host = "http${var.ssl_certificate != "/dev/null" ? "s" : ""}://${var.dns_name}"
       generated_host = "http://${google_compute_instance.compute_instance.internal_ip}"
    }
}

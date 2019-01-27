resource "google_service_account" "gitlab-ce" {
    account_id   = "gitlab-ce"
    display_name = "gitlab-ce"
}

module "gitlab_instance" {
  source = "../compute_instance"
  project = "${var.project}"
  region = "${var.region}"
  zone = "${var.zone}"
  data_volume = "${var.data_volume}"
  dns_name = "${var.dns_name}"
  runner_count = "${var.runner_count}"
  prefix = "${var.prefix}"
  initial_root_password = "${var.initial_root_password}"
  runner_token = "${var.runner_token}"
  runner_host = "${var.runner_host}"
  instance_name = "${var.instance_name}"
  service_account_email = "${var.service_account_email}"
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
       generated_host = "http://${module.gitlab_instance.internal_ip}"
    }
}



module "gitlab_runner" {
  source = "../compute_instance"
  project = "${var.project}"
  region = "${var.region}"
  zone = "${var.zone}"
  data_volume = "${var.dns_volume}"
  dns_name = "${var.dns_name}"
  dns_zone = "${var.dns_zone}"
  runner_count = "${var.runner_count}"
  prefix = "${var.prefix}"
  initial_root_password = "${var.initial_root_password}"
  runner_token = "${var.runner_token}"
  runner_host = "${var.runner_host}"
  instance_name = "${var.instance_name}"
  service_account_email = "${var.service_account_email}"

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

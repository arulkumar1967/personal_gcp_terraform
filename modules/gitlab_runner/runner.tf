

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
}
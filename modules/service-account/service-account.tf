resource "google_service_account" "service_account"{
  account_id = "${var.prefix}-svcacct-${var.service_name}"
  project = "${var.projectid}"
  display_name = "${var.prefix}-svcacct-${var.service_name}"
}

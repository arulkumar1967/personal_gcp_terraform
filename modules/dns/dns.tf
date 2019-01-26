resource "google_dns_managed_zone" "test" {
  count = "${var.dns_zone != "no_dns" ? 1 : 0}"
  name     = "${var.dns_zone}"
  dns_name = "${var.dns_name}."
  description = "Example Dev DNS Managed Zone"
}
resource "google_dns_managed_zone" "dns_managed_zone" {
  count = "${var.dns_zone != "no_dns" ? 1 : 0}"
  name     = "${var.dns_zone}"
  dns_name = "${var.dns_name}."
  description = "Example Dev DNS Managed Zone"
}

resource "google_dns_record_set" "dns_record_set" {
    count = "${var.dns_zone != "no_dns" ? 1 : 0}"
    name = "${var.dns_name}."
    type = "A"
    ttl = 300
    # TODO: This is really hard to read. I'd like to revisit at some point to clean it up.
    # But we shouldn't need two variables to specify DNS name
    managed_zone = "${google_dns_managed_zone.dns_managed_zone.name}"
    rrdatas = ["${var.server_ip}}"]
}
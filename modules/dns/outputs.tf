 output "dns_zone" {
     value = "${google_dns_managed_zone.dns_managed_zone.name}"
 }

output "dns_name" {
     value = "${google_dns_managed_zone.dns_managed_zone.dns_name}"
 }
 
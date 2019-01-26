 output "dns_zone" {
     value = "${google_dns_managed_zone.test.name}"
 }

output "dns_name" {
     value = "${google_dns_managed_zone.test.dns_name}"
 }
 
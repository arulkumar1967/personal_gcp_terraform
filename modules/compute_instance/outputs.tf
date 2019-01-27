 output "address" {
     value = "${google_compute_instance.compute_instance.network_interface.0.access_config.0.assigned_nat_ip}"
 }

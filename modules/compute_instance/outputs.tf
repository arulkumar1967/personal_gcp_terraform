 output "address" {
     value = "${google_compute_instance.gitlab-ce.network_interface.0.access_config.0.assigned_nat_ip}"
 }

 output "gitlab-ce_email" {
     value =  "${google_service_account.gitlab-ce.email}"
 }

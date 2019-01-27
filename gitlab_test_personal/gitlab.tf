module "gitlab_service_account" {  
  source = "../modules/service-account"
  project_id = "terraformpoc-229221"
  prefix = "test"
  service_name = "gitlab-instance"
}

module "gitlab_network" {
    source = "../modules/network"
    prefix = "test"
    # network
    # region
    # public_ports_ssl
    # public_ports_no_ssl
    # external_ports_name
    # ssl_key
    # ssl_certificate
    # deploy_gitlab
}

module "gitlab_server" {
  source = "../modules/gitlab_server_instance"
  project = "terraformpoc-229221"
  region = "europe-west2"
  zone = "europe-west2-c"
  data_volume = "gitlab-disk"
  dns_name = "gitlabpoc.example.com"
  runner_count = 2
  prefix = "test"
  initial_root_password = "K00uYFxohPBIdMLMDqEX"
  runner_token = "Nur19iz5KCG2ZzWW6_tr"
  runner_host = "http://londonuk.etouch.net."
  service_account_email = "{$module.gitlab_service_account.gcp_service_account.value}"
  //google_service_account.gitlab-ci-runner.email
}

module "gitlab_runner" {
  source = "../modules/gitlab_runner_instance"
  project = "terraformpoc-229221"
  region = "europe-west2"
  zone = "europe-west2-c"
  data_volume = "gitlab-disk"
  dns_name = "gitlabpoc.example.com"
  runner_count = 2
  prefix = "test"
  initial_root_password = "K00uYFxohPBIdMLMDqEX"
  runner_token = "Nur19iz5KCG2ZzWW6_tr"
  runner_host = "http://londonuk.etouch.net."
  service_account_email = "{$module.gitlab_service_account.gcp_service_account.value}"
  //google_service_account.gitlab-ci-runner.email
}

module "mydns" {
  source = "../modules/dns"
  auth_file = "/home/jayanthiarulkumar98/key.json"
  project = "terraformpoc-229221"
  region = "europe-west2"
  zone = "europe-west2-c"
  dns_name = "gitlabpoc.example.com"
  dns_zone = "gitlabpoc.example"
  server_ip = "${module.gitlab_server.address}"
  //{google_compute_instance.gitlab-ce.network_interface.0.access_config.0.assigned_nat_ip
}

output "gitlab-ce-service-account" {
    value = "${module.gitlab_service_account.gcp_service_account.vaule}"
}

output "address" {
    value = "${module.gitlab_server.gitlab_server_instance.address}"
}

output "runner_host" {
    value = "${module.gitlab_server.runner_host}"
}



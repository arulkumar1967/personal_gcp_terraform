terraform {
  backend "gcs" {
    bucket = "arul_terraform_states"
    prefix = "gitlab"
    credentials = "/home/jayanthiarulkumar98/key.json"
  }
}

module "mygitlab" {
  source = "../modules/gitlab_mod_rep"
  auth_file = "/home/jayanthiarulkumar98/key.json"
  project = "terraformpoc-229221"
  region = "europe-west2"
  zone = "europe-west2-c"
  data_volume = "gitlab-disk"
  dns_name = "gitlabpoc.example.com"
  runner_count = 2
  prefix = ""
  initial_root_password = "K00uYFxohPBIdMLMDqEX"
  runner_token = "Nur19iz5KCG2ZzWW6_tr"
  runner_host = "http://londonuk.etouch.net."
}

module "mydns" {
  source = "../modules/dns"
  auth_file = "/home/jayanthiarulkumar98/key.json"
  project = "terraformpoc-229221"
  region = "europe-west2"
  zone = "europe-west2-c"
  dns_name = "gitlabpoc.example.com"
  dns_zone = "gitlabpoc.example"
}


output "gitlab-ce-service-account" {
    value = "${module.mygitlab.gitlab-ce_email}"
}

output "gitlab-ci-runner-service-account" {
    value = "${module.mygitlab.gitlab-ci-runner_email}"
}

#output "gitlab-ci-runner-host" {
#    value = "${module.mygitlab.runner_host}"
#}

output "address" {
    value = "${module.mygitlab.address}"
}

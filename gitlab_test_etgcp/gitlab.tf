module "mygitlab" {
  source = "git::https://github.com/etgcp/gitlab_terraform.git"
  auth_file = "londonuk-890120be22b4.json"
  project = "londonuk"
  region = "europe-west2"
  zone = "europe-west2-c"
  config_file = "templates/gitlab.rb.append"
  data_volume = "gitlab-disk"
  dns_name = "londonuk.etouch.net"
  dns_zone = "londonuk-zone"
  runner_count = 1
  prefix = ""
  initial_root_password = "K00uYFxohPBIdMLMDqEX"
  runner_token = "Nur19iz5KCG2ZzWW6_tr"
}
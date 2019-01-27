terraform {
  backend "gcs" {
    bucket = "arul_terraform_states"
    prefix = "gitlab"
    credentials = "/home/jayanthiarulkumar98/key.json"
  }
}
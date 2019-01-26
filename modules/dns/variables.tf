variable "auth_file" {
    description = "The configuration file containing the credentials to connect to google"
}

variable "project" {
    description = "The project in Google Cloud to create the GitLab instance under"
}

variable "region" {
    description = "The region this all lives in. TODO can this be inferred from zone or vice versa?"
    default = "us-central1"
}

variable "zone" {
    description = "The zone to deploy the machine to"
    default = "us-central1-a"
}

variable "dns_name" {
    description = "The DNS name of the GitLab instance."
}

variable "dns_zone" {
    description = "The name of the DNS zone in Google Cloud that the DNS name should go under"
}



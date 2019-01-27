variable "network" {
    description = "The network for the instance to live on"
    default = "default"
}

variable "public_ports_ssl" {
    description = "A list of ports that need to be opened for GitLab to work"
    default = ["80", "443", "22"]
}

variable "public_ports_no_ssl" {
    description = "A list of ports that need to be opened for GitLab to work"
    default = ["80", "22"]
}

variable "region" {
    description = "The region this all lives in. TODO can this be inferred from zone or vice versa?"
    default = "us-central1"
}
variable "external_ports_name" {
    description = "The name of the external ports object, can be used to reuse lists"
    default =  "gitlab-external-ports"
}
variable "ssl_key" {
    description = "The SSL keyfile to use"
    default = "/dev/null"
}

variable "ssl_certificate" {
    description = "The SSL certificate file to use"
    default = "/dev/null"
}

variable "deploy_gitlab" {
    description = "Enable / Disable deploying a GitLab instance"
    default = true
}

variable "prefix" {
    description = "Prefix to resource names in cloud provider"
}
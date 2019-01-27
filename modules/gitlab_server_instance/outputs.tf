 output "address" {
     value = "${module.gitlab_instance.address}"
 }

 output "runner_host" {
    value = "${data.template_file.runner_host.rendered}"
}

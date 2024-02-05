resource "local_file" "etc_hosts" {
  filename        = "${path.module}/working/hosts.txt"
  file_permission = var.file_perms
  content = templatefile("${path.module}/templates/hosts.txt.tpl",
    {
      pce_core_nodes          = var.pce_core_nodes
      pce_data_nodes          = var.pce_data_nodes
      pce_lb_nodes            = var.pce_lb_nodes
      load_balancer           = var.lb_vip["ip_address"] != null ? var.lb_vip["ip_address"] : ""
      load_balancer_host_name = var.lb_vip["host_name"] != null ? var.lb_vip["host_name"] : ""
  })
}

resource "null_resource" "ansible_apply" {
  depends_on = [local_file.ansible_vars, local_file.ansible_hosts]
  provisioner "local-exec" {
    environment = var.ansible_environment_vars
    when        = create
    command     = <<EOT
      ansible-playbook --extra-vars '@${local_file.ansible_vars.filename}' -b -i ${local_file.ansible_hosts.filename}  ${path.module}/ansible/pce-build/pce-build.yaml
    EOT
  }
}


resource "local_file" "ansible_vars" {
  depends_on      = [local_file.ansible_hosts]
  filename        = "${path.module}/working/vars.yml"
  file_permission = var.file_perms
  content = templatefile("${path.module}/templates/vars.yml.tpl",
    {
      pce_software          = var.pce_rpm_name
      pce_ui_software       = var.pce_ui_rpm_name
      certificate_file      = var.cert_filename
      certificate_passwd    = var.cert_key_filename
      sde_key               = base64encode(random_string.sde_key.result)
      pce_fqdn              = var.lb_vip["host_name"]
      lb_vip                = var.lb_vip["ip_address"]
      sds                   = values(var.pce_core_nodes)[0]
      pce_domain_name       = join(".", reverse(slice(reverse(split(".", var.lb_vip["host_name"])), 0, 2)))
      pce_admin_user        = var.pce_admin_user
      pce_admin_fullname    = var.pce_admin_fullname
      pce_admin_passwd      = random_password.admin_ui.result
      ansible_ssh_user      = var.ansible_ssh_user
      ansible_password      = var.ansible_password
      ansible_sudo_password = var.ansible_sudo_password
      org_name              = var.pce_org_name
      root_ca_file          = var.root_ca_cert
      front_end_port        = var.front_end_port
      front_end_svc_port    = var.front_end_svc_port
      data_dir              = var.data_dir
      create_lb             = var.create_lb
      keepalived_auth       = length(random_string.keepalived) > 0 ? random_string.keepalived[0].result : ""
      set_hostname          = local.set_hostname
  })
  provisioner "local-exec" {
    environment = {
      ANSIBLE_HOST_KEY_CHECKING    = "False",
      ANSIBLE_DEPRECATION_WARNINGS = "True",
      ANSIBLE_STDOUT_CALLBACK      = "default",
      host_hey_checking            = "False"
      remote_tmp                   = "/tmp/"

    }
    when    = destroy
    command = <<EOT
    ansible-playbook --extra-vars '@${self.filename}' -b -i ${path.module}/working/hosts.yml ${path.module}/ansible/pce-destroy/pce-destroy.yaml
    EOT
  }
}

resource "local_file" "ansible_hosts" {
  filename        = "${path.module}/working/hosts.yml"
  file_permission = var.file_perms
  content = templatefile("${path.module}/templates/hosts.yml.tpl",
    {
      pce_core_nodes = values(var.pce_core_nodes)
      pce_data_nodes = values(var.pce_data_nodes)
      pce_lb_nodes   = values(var.pce_lb_nodes)
      create_lb      = var.create_lb
    }
  )
}

locals {
  set_hostname = {
    lb_vip         = var.lb_vip,
    pce_lb_nodes   = var.pce_lb_nodes,
    pce_core_nodes = var.pce_core_nodes,
    pce_data_nodes = var.pce_data_nodes,
  }
}

resource "random_string" "sde_key" {
  length  = 32
  special = true
  upper   = true
  lower   = true
}

resource "random_password" "admin_ui" {
  length  = 16
  special = true
  upper   = true
  lower   = true
}

resource "random_string" "keepalived" {
  count   = var.create_lb ? 1 : 0
  length  = 12
  special = true
  upper   = true
  lower   = true
}

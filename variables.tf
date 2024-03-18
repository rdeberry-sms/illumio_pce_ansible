variable "pce_org_name" {
  type        = string
  description = "Organization Name"
}

variable "ansible_ssh_user" {
  description = "Name of user to use for ansible"
  type        = string
}

variable "pce_rpm_name" {
  description = "RPM of PCE software"
  type        = string
}

variable "pce_ui_rpm_name" {
  description = "RPM of PCE UI software"
  type        = string
}

#variable "lb_vip" {
#  description = "Map containing host_name and ip_address of VIP"
#  type        = map(string)
#  default = {
#    host_name  = ""
#    ip_address = ""
#  }
#}

variable "lb_vip" {
  description = "Map containing host_name and ip_address of VIP"
  type = object({
    host_name  = string
    ip_address = string
  })
  default = {
    host_name  = ""
    ip_address = ""
  }

  validation {
    condition     = var.lb_vip["host_name"] != "" || var.lb_vip["ip_address"] != ""
    error_message = "host_name is required if ip_address is not provided."
  }
}



variable "pce_admin_user" {
  description = "Email address of admin user"
  type        = string
}

variable "pce_admin_fullname" {
  description = "Full Name of admin user"
  type        = string
}

variable "cert_filename" {
  description = "Name of certificate file"
  type        = string
  default     = "server.crt"
}

variable "cert_key_filename" {
  description = "Name of certificate file"
  type        = string
  default     = "server.key"
}

variable "create_certificates" {
  type        = bool
  description = "Whether or not to create Certificates - If false you will need to supply cert and key file"
  default     = false
}

variable "ansible_password" {
  description = "Password of ansible user"
  type        = string
  default     = ""
  sensitive   = true
}

variable "ansible_sudo_password" {
  description = "Password of ansible user"
  type        = string
  default     = ""
  sensitive   = true
}

variable "pce_core_nodes" {
  description = "IP Addresses of all Core Nodes - must be IP address then FQDN"
  type        = map(string)
  validation {
    condition     = can(var.pce_core_nodes) && (length(keys(var.pce_core_nodes)) == 1 || length(keys(var.pce_core_nodes)) == 2 || length(keys(var.pce_core_nodes)) == 4)
    error_message = "pce_core must have 1, 2, or 4 elements."
  }
}

variable "pce_data_nodes" {
  description = "IP Addresses of all Data Nodes - must be IP address then FQDN"
  type        = map(string)
  default     = {}
  validation {
    condition     = length(keys(var.pce_data_nodes)) == 0 || length(keys(var.pce_data_nodes)) == 2
    error_message = "pce_data must have exactly zero or two elements."
  }
}

variable "pce_lb_nodes" {
  description = "IP Addresses of all LB Nodes - must be IP address then FQDN"
  type        = map(string)
  default     = {}
  validation {
    condition     = length(keys(var.pce_lb_nodes)) == 0 || length(keys(var.pce_lb_nodes)) == 2
    error_message = "LB must have exactly zero or two elements."
  }
}

variable "cert_ca_country" {
  description = "Country"
  type        = string
  default     = "US"
}

variable "cert_ca_common_name" {
  description = "CN of CA certificate"
  type        = string
  default     = "Example Inc."
}

variable "cert_ca_org" {
  description = "Org of CA certificate"
  type        = string
  default     = "IT department"
}

variable "ca_allowed_uses" {
  description = "Allowed Certificate uses"
  type        = list(string)
  default = [
    "digital_signature",
    "cert_signing",
    "crl_signing",
    "key_encipherment",
  ]
}

variable "local_ss_allowed_uses" {
  description = "Allowed Certificate uses"
  type        = list(string)
  default = [
    "digital_signature",
    "key_encipherment",
    "server_auth",
    "client_auth",
  ]
}

variable "tls_algorithm" {
  description = "Algorithm used for private key"
  type        = string
  default     = "RSA"
}

variable "tls_bits" {
  description = "Bit Encryption"
  type        = number
  default     = 4096
}

variable "file_perms" {
  description = "Algorithm used for private key"
  type        = number
  default     = 0640
}

variable "cert_validity_period" {
  description = "How long the Cert should be valid for"
  type        = number
  default     = 12000
}

variable "root_ca_cert" {
  description = "Algorithm used for private key"
  type        = string
  default     = "root_ca.crt"
}

variable "ansible_environment_vars" {
  description = "Environment Variables for Ansible"
  type        = map(string)
  default = {
    ANSIBLE_HOST_KEY_CHECKING    = "False",
    ANSIBLE_DEPRECATION_WARNINGS = "True",
    ANSIBLE_STDOUT_CALLBACK      = "default",
    host_hey_checking            = "False",
    remote_tmp                   = "/tmp/",
    gathering                    = "smart",
    fact_caching_timeout         = "86400",
    pipelining                   = "True",
    display_skipped_hosts        = "no",
    callbacks_enabled            = "profile_tasks"
  }
}

variable "front_end_port" {
  description = "Front End Port"
  type        = number
  default     = 8443
}

variable "front_end_svc_port" {
  description = "Front End Port"
  type        = number
  default     = 8444
}

variable "data_dir" {
  description = "Data directory for traffic datastore"
  type        = string
  default     = "/var/lib/illumio-pce/data/traffic"
}

variable "create_lb" {
  description = "Create Load Balancers"
  type        = bool
  default     = false
}

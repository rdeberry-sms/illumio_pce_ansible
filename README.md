# TF code base
## Introduction
This is sample readme for terraform module
<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5.5 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 4 |
## Usage
### See examples folder for full example
### Basic usage of this module is as follows:
#### You can provide your own certs or have the module create them
  - Follow this link for guidance on cert creation (https://my.illumio.com/apex/article?name=Preparing-Certificates-for-an-Illumio-MNC-Installation)
##### If you are providing your own certs the following files need to be in the "certs" dir
      server.crt - This is your Server certificate and Root CA/Intermediate certificates
      server.key - Private Key for your Certificate
      root_ca.crt - The Root CA certificate
##### If you need this module to create a TLS certificate you must set the following variables
      create_certificates = true
      org_name = "Name of your organization"
      cert_ca_common_name = "CN of your CA"
      cert_ca_org = "Name of your CA organization"
      dns_names = ["List of DNS hostnames of all Nodes in Cluster"]

##### As you can see below there are required variables that must be set in addition to those there are a few that could be necessary for your deployment
###### This module assumes you are using ssh keys, if you are not you will need to populate the following variables
       ansible_password = "Password for your ansible_ssh_user"
       ansible_sudo_password = "If your user requires a sudo password, suppy it here"
##### Most of what you see is self explanatory but the one thing that is not that clear is a Single Node Cluster(snc0)
###### If you plan to deploy a snc0 you must only include the (1) IP in
       pce_core
       do not put pce_data in your tf or hcl file
#### The admin ui password is randomly generated and should be changed once you login for the first time
##### In order to retrieve the Admin UI password; issue the following command
      terraform show -json | jq -r '.values.root_module.child_modules | .[].resources | .[] | select(.address == "module.pce_install.random_password.admin_ui").values.result

```hcl
module "example" {
	 source  = "<module-path>"

	 # Required variables
	 ansible_ssh_user  = 
	 pce_admin_fullname  = 
	 pce_admin_user  = 
	 pce_core_nodes  = 
	 pce_org_name  = 
	 pce_rpm_name  = 
	 pce_ui_rpm_name  = 

	 # Optional variables
	 ansible_environment_vars  = {
  "ANSIBLE_DEPRECATION_WARNINGS": "True",
  "ANSIBLE_HOST_KEY_CHECKING": "False",
  "ANSIBLE_STDOUT_CALLBACK": "default",
  "callbacks_enabled": "profile_tasks",
  "display_skipped_hosts": "no",
  "fact_caching_timeout": "86400",
  "gathering": "smart",
  "host_hey_checking": "False",
  "pipelining": "True",
  "remote_tmp": "/tmp/"
}
	 ansible_password  = ""
	 ansible_sudo_password  = ""
	 ca_allowed_uses  = [
  "digital_signature",
  "cert_signing",
  "crl_signing",
  "key_encipherment"
]
	 cert_ca_common_name  = "Example Inc."
	 cert_ca_country  = "US"
	 cert_ca_org  = "IT department"
	 cert_filename  = "server.crt"
	 cert_key_filename  = "server.key"
	 cert_validity_period  = 12000
	 create_certificates  = false
	 create_lb  = false
	 data_dir  = "/var/lib/illumio-pce/data/traffic"
	 file_perms  = 640
	 front_end_port  = 8443
	 front_end_svc_port  = 8444
	 lb_vip  = {
  "host_name": "",
  "ip_address": ""
}
	 local_ss_allowed_uses  = [
  "digital_signature",
  "key_encipherment",
  "server_auth",
  "client_auth"
]
	 pce_data_nodes  = {}
	 pce_lb_nodes  = {}
	 root_ca_cert  = "root_ca.crt"
	 tls_algorithm  = "RSA"
	 tls_bits  = 4096
}
```
## Resources

| Name | Type |
|------|------|
| [local_file.ansible_hosts](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.ansible_vars](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.cert](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.cert_key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.etc_hosts](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.full_cert](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.root_ca_crt](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.ansible_apply](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_password.admin_ui](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_string.keepalived](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [random_string.sde_key](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [tls_cert_request.cm_internal_csr](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/cert_request) | resource |
| [tls_locally_signed_cert.cm_internal](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/locally_signed_cert) | resource |
| [tls_private_key.cm_ca](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_private_key.cm_internal](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_self_signed_cert.cm_ca](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert) | resource |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ansible_environment_vars"></a> [ansible\_environment\_vars](#input\_ansible\_environment\_vars) | Environment Variables for Ansible | `map(string)` | <pre>{<br>  "ANSIBLE_DEPRECATION_WARNINGS": "True",<br>  "ANSIBLE_HOST_KEY_CHECKING": "False",<br>  "ANSIBLE_STDOUT_CALLBACK": "default",<br>  "callbacks_enabled": "profile_tasks",<br>  "display_skipped_hosts": "no",<br>  "fact_caching_timeout": "86400",<br>  "gathering": "smart",<br>  "host_hey_checking": "False",<br>  "pipelining": "True",<br>  "remote_tmp": "/tmp/"<br>}</pre> | no |
| <a name="input_ansible_password"></a> [ansible\_password](#input\_ansible\_password) | Password of ansible user | `string` | `""` | no |
| <a name="input_ansible_ssh_user"></a> [ansible\_ssh\_user](#input\_ansible\_ssh\_user) | Name of user to use for ansible | `string` | n/a | yes |
| <a name="input_ansible_sudo_password"></a> [ansible\_sudo\_password](#input\_ansible\_sudo\_password) | Password of ansible user | `string` | `""` | no |
| <a name="input_ca_allowed_uses"></a> [ca\_allowed\_uses](#input\_ca\_allowed\_uses) | Allowed Certificate uses | `list(string)` | <pre>[<br>  "digital_signature",<br>  "cert_signing",<br>  "crl_signing",<br>  "key_encipherment"<br>]</pre> | no |
| <a name="input_cert_ca_common_name"></a> [cert\_ca\_common\_name](#input\_cert\_ca\_common\_name) | CN of CA certificate | `string` | `"Example Inc."` | no |
| <a name="input_cert_ca_country"></a> [cert\_ca\_country](#input\_cert\_ca\_country) | Country | `string` | `"US"` | no |
| <a name="input_cert_ca_org"></a> [cert\_ca\_org](#input\_cert\_ca\_org) | Org of CA certificate | `string` | `"IT department"` | no |
| <a name="input_cert_filename"></a> [cert\_filename](#input\_cert\_filename) | Name of certificate file | `string` | `"server.crt"` | no |
| <a name="input_cert_key_filename"></a> [cert\_key\_filename](#input\_cert\_key\_filename) | Name of certificate file | `string` | `"server.key"` | no |
| <a name="input_cert_validity_period"></a> [cert\_validity\_period](#input\_cert\_validity\_period) | How long the Cert should be valid for | `number` | `12000` | no |
| <a name="input_create_certificates"></a> [create\_certificates](#input\_create\_certificates) | Whether or not to create Certificates - If false you will need to supply cert and key file | `bool` | `false` | no |
| <a name="input_create_lb"></a> [create\_lb](#input\_create\_lb) | Create Load Balancers | `bool` | `false` | no |
| <a name="input_data_dir"></a> [data\_dir](#input\_data\_dir) | Data directory for traffic datastore | `string` | `"/var/lib/illumio-pce/data/traffic"` | no |
| <a name="input_file_perms"></a> [file\_perms](#input\_file\_perms) | Algorithm used for private key | `number` | `640` | no |
| <a name="input_front_end_port"></a> [front\_end\_port](#input\_front\_end\_port) | Front End Port | `number` | `8443` | no |
| <a name="input_front_end_svc_port"></a> [front\_end\_svc\_port](#input\_front\_end\_svc\_port) | Front End Port | `number` | `8444` | no |
| <a name="input_lb_vip"></a> [lb\_vip](#input\_lb\_vip) | Map containing host\_name and ip\_address of VIP | <pre>object({<br>    host_name  = string<br>    ip_address = string<br>  })</pre> | <pre>{<br>  "host_name": "",<br>  "ip_address": ""<br>}</pre> | no |
| <a name="input_local_ss_allowed_uses"></a> [local\_ss\_allowed\_uses](#input\_local\_ss\_allowed\_uses) | Allowed Certificate uses | `list(string)` | <pre>[<br>  "digital_signature",<br>  "key_encipherment",<br>  "server_auth",<br>  "client_auth"<br>]</pre> | no |
| <a name="input_pce_admin_fullname"></a> [pce\_admin\_fullname](#input\_pce\_admin\_fullname) | Full Name of admin user | `string` | n/a | yes |
| <a name="input_pce_admin_user"></a> [pce\_admin\_user](#input\_pce\_admin\_user) | Email address of admin user | `string` | n/a | yes |
| <a name="input_pce_core_nodes"></a> [pce\_core\_nodes](#input\_pce\_core\_nodes) | IP Addresses of all Core Nodes - must be IP address then FQDN | `map(string)` | n/a | yes |
| <a name="input_pce_data_nodes"></a> [pce\_data\_nodes](#input\_pce\_data\_nodes) | IP Addresses of all Data Nodes - must be IP address then FQDN | `map(string)` | `{}` | no |
| <a name="input_pce_lb_nodes"></a> [pce\_lb\_nodes](#input\_pce\_lb\_nodes) | IP Addresses of all LB Nodes - must be IP address then FQDN | `map(string)` | `{}` | no |
| <a name="input_pce_org_name"></a> [pce\_org\_name](#input\_pce\_org\_name) | Organization Name | `string` | n/a | yes |
| <a name="input_pce_rpm_name"></a> [pce\_rpm\_name](#input\_pce\_rpm\_name) | RPM of PCE software | `string` | n/a | yes |
| <a name="input_pce_ui_rpm_name"></a> [pce\_ui\_rpm\_name](#input\_pce\_ui\_rpm\_name) | RPM of PCE UI software | `string` | n/a | yes |
| <a name="input_root_ca_cert"></a> [root\_ca\_cert](#input\_root\_ca\_cert) | Algorithm used for private key | `string` | `"root_ca.crt"` | no |
| <a name="input_tls_algorithm"></a> [tls\_algorithm](#input\_tls\_algorithm) | Algorithm used for private key | `string` | `"RSA"` | no |
| <a name="input_tls_bits"></a> [tls\_bits](#input\_tls\_bits) | Bit Encryption | `number` | `4096` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin_ui_passwd"></a> [admin\_ui\_passwd](#output\_admin\_ui\_passwd) | Admin UI Password |
<!-- END_AUTOMATED_TF_DOCS_BLOCK -->
## Footer
Contributor Names

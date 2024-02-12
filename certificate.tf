
resource "tls_private_key" "cm_ca" {
  count     = var.create_certificates ? 1 : 0
  algorithm = var.tls_algorithm
  rsa_bits  = var.tls_bits
}

resource "tls_self_signed_cert" "cm_ca" {
  count                 = var.create_certificates ? 1 : 0
  private_key_pem       = tls_private_key.cm_ca[0].private_key_pem
  validity_period_hours = var.cert_validity_period
  is_ca_certificate     = true
  allowed_uses          = var.ca_allowed_uses

  subject {
    country      = var.cert_ca_country
    common_name  = var.cert_ca_common_name
    organization = var.cert_ca_org
  }
}

resource "tls_private_key" "cm_internal" {
  count     = var.create_certificates ? 1 : 0
  algorithm = var.tls_algorithm
  rsa_bits  = var.tls_bits
}

resource "tls_cert_request" "cm_internal_csr" {
  count           = var.create_certificates ? 1 : 0
  private_key_pem = tls_private_key.cm_internal[0].private_key_pem
  subject {
    common_name = var.lb_vip["host_name"] != null ? var.lb_vip["host_name"] : keys(var.pce_core_nodes)[0]
  }
  dns_names = flatten([
    keys(var.pce_core_nodes),
    keys(var.pce_data_nodes),
    var.lb_vip["host_name"]
  ])
  ip_addresses = flatten([
    values(var.pce_core_nodes),
    values(var.pce_data_nodes),
    var.lb_vip["ip_address"]
  ])
}

resource "tls_locally_signed_cert" "cm_internal" {
  count                 = var.create_certificates ? 1 : 0
  cert_request_pem      = tls_cert_request.cm_internal_csr[0].cert_request_pem
  ca_private_key_pem    = tls_private_key.cm_ca[0].private_key_pem
  ca_cert_pem           = tls_self_signed_cert.cm_ca[0].cert_pem
  validity_period_hours = var.cert_validity_period
  allowed_uses          = var.local_ss_allowed_uses
}

resource "local_file" "cert" {
  count           = var.create_certificates ? 1 : 0
  content         = join("", [tls_locally_signed_cert.cm_internal[0].cert_pem, tls_self_signed_cert.cm_ca[0].cert_pem])
  filename        = "${path.cwd}/certs/${var.cert_filename}"
  file_permission = var.file_perms
}

resource "local_file" "cert_key" {
  count           = var.create_certificates ? 1 : 0
  content         = tls_private_key.cm_internal[0].private_key_pem
  filename        = "${path.cwd}/certs/${var.cert_key_filename}"
  file_permission = var.file_perms
}

resource "local_file" "root_ca_crt" {
  count           = var.create_certificates ? 1 : 0
  content         = tls_self_signed_cert.cm_ca[0].cert_pem
  filename        = "${path.cwd}/certs/${var.root_ca_cert}"
  file_permission = var.file_perms
}

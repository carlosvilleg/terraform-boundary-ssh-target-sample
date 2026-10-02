
resource "boundary_credential_library_vault_ssh_certificate" "ssh" {
  for_each = tomap(local.credential_libs)
  name = "${each.value.target_type}-${each.value.role}"
  description         = "Vault credential library for ${each.value.role} role on ${each.value.target_type}"
  credential_store_id = var.credential_store_id
  path                = each.value.vault_path
  username = each.value.ssh_username
  key_type = "rsa"
  key_bits = 2048
  extensions = {
    permit-pty = ""
  }
}



locals {
	credential_libs = {for v in var.ssh_roles: v.name => {role=v.name,
		ssh_username = v.ssh_username,
		group_id = v.idp_group_id,
		vault_role = v.vault_role_name,
		vault_path = "${var.vault_engine_path}/issue/${v.vault_role_name}"
		target_type = "ssh"}}
}

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


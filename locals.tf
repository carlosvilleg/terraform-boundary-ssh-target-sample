
data "boundary_scope" "org" {
	name = var.boundary_org_name
	scope_id = "global"
}

data "boundary_scope" "project" {
	name = var.boundary_project_name
	scope_id = data.boundary_scope.org.id
}

locals {
	credential_libs = {for v in var.ssh_roles: v.name => {role=v.name,
		ssh_username = v.ssh_username,
		group_id = v.idp_group_id,
		vault_role = v.vault_role_name,
		vault_path = "${var.vault_engine_path}/issue/${v.vault_role_name}"
		target_type = "ssh"}}

	ssh_target_and_roles = setproduct(var.ssh_roles, var.ssh_targets)

	ssh_targets =  {for p in local.ssh_target_and_roles: "${p[1].name}-${p[0].name}" => {
		name="${p[1].name}-${p[0].name}",
		description = "This target grants ssh access for the ${p[0].name} role to ${p[1].name}",
		credential_library_id = boundary_credential_library_vault_ssh_certificate.ssh["${p[0].name}"].id,
		storage_bucket_id = var.boundary_storage_bucket_id,
		host_source_id = var.host_source_id,
		cloud = p[1].cloud,
		region = p[1].region,
		}}
}



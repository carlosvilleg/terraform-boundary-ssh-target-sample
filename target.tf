
locals {
	ssh_target_and_roles = setproduct(var.ssh_roles, var.ssh_targets)

	ssh_targets =  {for p in local.ssh_target_and_roles: "${p[1].name}-${p[0].name}" => {
		name="${p[1].name}-${p[0].name}",
		description = "This target grants ssh access for the ${p[0].name} role to ${p[1].tier} servers for ${p[1].application} in ${p[1].environment}",
		credential_library_id = boundary_credential_library_vault_ssh_certificate.ssh["${p[0].name}"].id,
		storage_bucket_id = var.boundary_storage_bucket_id,
		host_source_id = boundary_host_set_plugin.ssh["${p[1].application}-${p[1].tier}-${p[1].environment}"].id
		cloud = p[1].cloud,
		region = p[1].region,
		}}
}

resource "boundary_target" "ssh_session_recording" {
  for_each = local.ssh_targets
  name         = each.key
  description  = each.value.description
  type         = "ssh"
  default_port = "22"
  scope_id     = data.boundary_scope.project.id
  host_source_ids = [
    each.value.host_source_id
    //boundary_host_set_plugin.ssh["${each.value.application}-${each.value.tier}-${each.value.environment}"]
  ]
  injected_application_credential_source_ids = [
    each.value.credential_library_id
  ]
  enable_session_recording = true
  storage_bucket_id        = each.value.storage_bucket_id

  egress_worker_filter = "\"egress\" in \"/tags/type\" and `${each.value.cloud}` in \"/tags/cloud\" and `${each.value.region}` in \"/tags/region\""
}


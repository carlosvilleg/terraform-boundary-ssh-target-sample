
locals {
	ssh_roles = {for v in var.ssh_roles: v.name => v}
	ssh_targets_per_role = { for role in keys(local.ssh_roles): role => [for k, v in local.ssh_targets: v if v.role_name == role]}
	ssh_target_ids_per_role = { for k, v in local.ssh_targets_per_role: k => [for t in local.ssh_targets_per_role[k]: boundary_target.ssh_session_recording[t.name].id ] }
}


resource "boundary_role" "target" {
  for_each = local.ssh_roles

  name         = "ssh-${each.key}"
  description = "Grants access to the SSH for the ${each.key} role"
  scope_id        = data.boundary_scope.project.id
  grant_scope_ids = [ "this" ]
  grant_strings   = ["ids=${join(",", local.ssh_target_ids_per_role[each.key])};type=target;actions=list,read,authorize-session",
 	 "ids=*;type=target;actions=list"]
  principal_ids   = [each.value.idp_group_id]
}


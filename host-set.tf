
locals {
	ssh_hosts = {for v in var.ssh_targets: "${v.application}-${v.tier}-${v.environment}" => merge(v, {filter=templatefile("${path.module}/filter.tftpl", v)})}
}

resource "boundary_host_set_plugin" "ssh" {
  for_each = local.ssh_hosts

  name        = "ssh-${each.key}"
  description = "SSH Host Set for the ${each.value.tier} tier of the ${each.value.application} application in ${each.value.environment}"
  host_catalog_id  = var.host_source_id
  attributes_json = "{\"filters\": ${each.value.filter}}"
}


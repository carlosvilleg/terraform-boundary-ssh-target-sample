
output "target_ids" {
	description = "Id for the Boundary targets, per role"
	value = local.ssh_target_ids_per_role
}


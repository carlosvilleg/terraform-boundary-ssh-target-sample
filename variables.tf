
variable "boundary_org_name" {
	type = string
	description = "Boundary Organization name for this Boundary project"
	validation {
		condition = var.boundary_org_name != null && var.boundary_org_name != ""
		error_message = "Organization name must be specified and must not be empty"
	}
}

variable "boundary_project_name" {
	type = string
	description = "Project name for this Boundary project"
	validation {
		condition = var.boundary_project_name != null && var.boundary_project_name != ""
		error_message = "Project name must be specified and must not be empty"
	}
}

variable "boundary_storage_bucket_id" {
	type = string
	description = "Bucket id for session recording available for this project"
}

variable "credential_store_id" {
	type = string
	description = "Credential store id for Vault in this project and region"
}

variable "vault_engine_path" {
	type = string
	
}

variable "ssh_roles" {
	type = list(object({
			name = string
			ssh_username = string
			vault_role_name = string
			idp_group_id = string
		}))
}

variable "ssh_targets" {
	type = list(object({
		name=string,
		cloud = string,
		region = string,
	}))
}

variable "host_source_id" {
	type = string
}



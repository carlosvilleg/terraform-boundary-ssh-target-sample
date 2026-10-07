
module "ssh-aws" {
	source = "../terraform-boundary-ssh-target-sample"

	boundary_org_name = "customer"
	boundary_project_name = "test1aws"
	credential_store_id = "csvlt_..."
	boundary_storage_bucket_id = "sb_..."
	host_source_id = "hcplg_..."  # host catalog id

	vault_engine_path = "ssh"

	ssh_roles = [{
				name = "user"
				ssh_username = "ubuntu"
				vault_role_name = "boundary"
				idp_group_id = module.aws-project.users_managed_group_id
			},
			{
				name = "admin"
				ssh_username = "root"
				vault_role_name = "boundary"
				idp_group_id = module.aws-project.admins_managed_group_id
	}]

	ssh_targets = [{
		name="test1-app-dev",
		cloud="aws",
		region="us-east-2",
		application="test1",
		environment="dev",
		tier="app",
		},{
		name="test1-web-dev",
		cloud="aws",
		region="us-east-2",
		application="test1",
		environment="dev",
		tier="web",
	}]



}



data "boundary_scope" "org" {
	name = var.boundary_org_name
	scope_id = "global"
}

data "boundary_scope" "project" {
	name = var.boundary_project_name
	scope_id = data.boundary_scope.org.id
}


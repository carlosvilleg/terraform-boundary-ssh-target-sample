
resource "boundary_target" "ssh_session_recording" {
  for_each = local.ssh_targets
  name         = each.key
  description  = each.value.description
  type         = "ssh"
  default_port = "22"
  scope_id     = data.boundary_scope.project.id
  host_source_ids = [
    each.value.host_source_id
  ]
  injected_application_credential_source_ids = [
    each.value.credential_library_id
  ]
  enable_session_recording = true
  storage_bucket_id        = each.value.storage_bucket_id

  egress_worker_filter = "\"egress\" in \"/tags/type\" and `${each.value.cloud}` in \"/tags/cloud\" and `${each.value.region}` in \"/tags/region\""
}


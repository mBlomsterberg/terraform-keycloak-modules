output "groups_scope_id" {
  description = "Internal UUID of the groups scope."
  value       = module.groups.id
}

output "groups_scope_name" {
  description = "Name of the groups scope — pass this to client default_scopes or optional_scopes."
  value       = module.groups.name
}

output "profile_extended_scope_name" {
  description = "Name of the profile_extended scope."
  value       = module.profile_extended.name
}

output "api_v1_scope_name" {
  description = "Name of the api_v1 scope."
  value       = module.api_v1.name
}

output "groups_mapper_ids" {
  description = "Map of group-membership mapper name => UUID for the groups scope."
  value       = module.groups.group_membership_mapper_ids
}

output "api_v1_audience_mapper_ids" {
  description = "Map of audience mapper name => UUID for the api_v1 scope."
  value       = module.api_v1.audience_mapper_ids
}

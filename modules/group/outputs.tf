output "id" {
  description = "Internal Keycloak UUID of the group."
  value       = try(keycloak_group.this[0].id, null)
}

output "name" {
  description = "Display name of the group."
  value       = try(keycloak_group.this[0].name, null)
}

output "path" {
  description = "Full hierarchical path of the group (e.g. /engineering/backend)."
  value       = try(keycloak_group.this[0].path, null)
}

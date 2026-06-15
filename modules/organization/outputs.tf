output "id" {
  description = "Internal Keycloak UUID of the organization. Pass this as organization_id to identity providers, groups, and other resources that can be scoped to an organization."
  value       = try(keycloak_organization.this[0].id, null)
}

output "name" {
  description = "Display name of the organization."
  value       = try(keycloak_organization.this[0].name, null)
}

output "alias" {
  description = "Unique alias of the organization."
  value       = try(keycloak_organization.this[0].alias, null)
}

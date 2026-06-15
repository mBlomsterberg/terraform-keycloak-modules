################################################################################
# Standalone Keycloak role module — outputs
################################################################################

output "id" {
  description = "Internal Keycloak UUID of the role. Use this when wiring the role into composite roles or group/user role mappings."
  value       = keycloak_role.this.id
}

output "name" {
  description = "The role name."
  value       = keycloak_role.this.name
}

output "client_id" {
  description = "Internal client ID this role is scoped to, or null for a realm role."
  value       = keycloak_role.this.client_id
}

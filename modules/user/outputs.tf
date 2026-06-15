output "id" {
  description = "Internal Keycloak UUID of the user. Pass this as user_id to keycloak_user_groups, keycloak_user_roles, and keycloak_group_memberships."
  value       = try(keycloak_user.this[0].id, null)
}

output "username" {
  description = "Username of the user."
  value       = try(keycloak_user.this[0].username, null)
}

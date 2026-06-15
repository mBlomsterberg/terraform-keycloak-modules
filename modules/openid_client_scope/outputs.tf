output "id" {
  description = "Internal Keycloak UUID of the client scope."
  value       = try(keycloak_openid_client_scope.this[0].id, null)
}

output "name" {
  description = "Name of the client scope. Clients reference scopes by this name in default_scopes and optional_scopes lists."
  value       = try(keycloak_openid_client_scope.this[0].name, null)
}

output "user_attribute_mapper_ids" {
  description = "Map of user-attribute mapper name => Keycloak mapper UUID."
  value       = { for k, v in keycloak_openid_user_attribute_protocol_mapper.this : k => v.id }
}

output "user_property_mapper_ids" {
  description = "Map of user-property mapper name => Keycloak mapper UUID."
  value       = { for k, v in keycloak_openid_user_property_protocol_mapper.this : k => v.id }
}

output "group_membership_mapper_ids" {
  description = "Map of group-membership mapper name => Keycloak mapper UUID."
  value       = { for k, v in keycloak_openid_group_membership_protocol_mapper.this : k => v.id }
}

output "user_realm_role_mapper_ids" {
  description = "Map of user-realm-role mapper name => Keycloak mapper UUID."
  value       = { for k, v in keycloak_openid_user_realm_role_protocol_mapper.this : k => v.id }
}

output "user_client_role_mapper_ids" {
  description = "Map of user-client-role mapper name => Keycloak mapper UUID."
  value       = { for k, v in keycloak_openid_user_client_role_protocol_mapper.this : k => v.id }
}

output "audience_mapper_ids" {
  description = "Map of audience mapper name => Keycloak mapper UUID."
  value       = { for k, v in keycloak_openid_audience_protocol_mapper.this : k => v.id }
}

output "hardcoded_claim_mapper_ids" {
  description = "Map of hardcoded-claim mapper name => Keycloak mapper UUID."
  value       = { for k, v in keycloak_openid_hardcoded_claim_protocol_mapper.this : k => v.id }
}

output "full_name_mapper_ids" {
  description = "Map of full-name mapper name => Keycloak mapper UUID."
  value       = { for k, v in keycloak_openid_full_name_protocol_mapper.this : k => v.id }
}

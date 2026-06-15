output "id" {
  description = "Internal Keycloak UUID of the OIDC identity provider."
  value       = try(keycloak_oidc_identity_provider.this[0].id, null)
}

output "alias" {
  description = "Alias of the identity provider — use this as identity_provider_alias when referencing the provider outside the module."
  value       = try(keycloak_oidc_identity_provider.this[0].alias, null)
}

output "internal_id" {
  description = "Internal ID assigned by Keycloak to the identity provider (distinct from the alias)."
  value       = try(keycloak_oidc_identity_provider.this[0].internal_id, null)
}

output "attribute_importer_mapper_ids" {
  description = "Map of attribute-importer mapper name => Keycloak mapper UUID."
  value       = { for k, v in keycloak_attribute_importer_identity_provider_mapper.this : k => v.id }
}

output "attribute_to_role_mapper_ids" {
  description = "Map of attribute-to-role mapper name => Keycloak mapper UUID."
  value       = { for k, v in keycloak_attribute_to_role_identity_provider_mapper.this : k => v.id }
}

output "hardcoded_role_mapper_ids" {
  description = "Map of hardcoded-role mapper name => Keycloak mapper UUID."
  value       = { for k, v in keycloak_hardcoded_role_identity_provider_mapper.this : k => v.id }
}

output "hardcoded_attribute_mapper_ids" {
  description = "Map of hardcoded-attribute mapper name => Keycloak mapper UUID."
  value       = { for k, v in keycloak_hardcoded_attribute_identity_provider_mapper.this : k => v.id }
}

output "hardcoded_group_mapper_ids" {
  description = "Map of hardcoded-group mapper name => Keycloak mapper UUID."
  value       = { for k, v in keycloak_hardcoded_group_identity_provider_mapper.this : k => v.id }
}

output "user_template_importer_mapper_ids" {
  description = "Map of user-template-importer mapper name => Keycloak mapper UUID."
  value       = { for k, v in keycloak_user_template_importer_identity_provider_mapper.this : k => v.id }
}

output "custom_mapper_ids" {
  description = "Map of custom mapper name => Keycloak mapper UUID."
  value       = { for k, v in keycloak_custom_identity_provider_mapper.this : k => v.id }
}

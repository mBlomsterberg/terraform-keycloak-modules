output "okta_alias" {
  description = "Alias of the Okta OIDC identity provider."
  value       = module.okta.alias
}

output "okta_internal_id" {
  description = "Internal Keycloak UUID of the Okta identity provider."
  value       = module.okta.internal_id
}

output "google_alias" {
  description = "Alias of the Google identity provider."
  value       = module.google.alias
}

output "google_internal_id" {
  description = "Internal Keycloak UUID of the Google identity provider."
  value       = module.google.internal_id
}

output "microsoft_alias" {
  description = "Alias of the Microsoft identity provider."
  value       = module.microsoft.alias
}

output "microsoft_internal_id" {
  description = "Internal Keycloak UUID of the Microsoft identity provider."
  value       = module.microsoft.internal_id
}

output "github_alias" {
  description = "Alias of the GitHub identity provider."
  value       = module.github.alias
}

output "github_internal_id" {
  description = "Internal Keycloak UUID of the GitHub identity provider."
  value       = module.github.internal_id
}

output "corporate_saml_alias" {
  description = "Alias of the corporate SAML identity provider."
  value       = module.corporate_saml.alias
}

output "corporate_saml_internal_id" {
  description = "Internal Keycloak UUID of the corporate SAML identity provider."
  value       = module.corporate_saml.internal_id
}

output "okta_attribute_importer_mapper_ids" {
  description = "Map of attribute-importer mapper name => UUID for the Okta provider."
  value       = module.okta.attribute_importer_mapper_ids
}

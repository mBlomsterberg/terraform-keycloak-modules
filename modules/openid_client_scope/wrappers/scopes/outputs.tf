################################################################################
# Keycloak OpenID client scopes wrapper — outputs
################################################################################

output "wrapper" {
  description = "Map of all managed openid_client_scope module instances, keyed by the same key used in var.items."
  value       = module.scope
}

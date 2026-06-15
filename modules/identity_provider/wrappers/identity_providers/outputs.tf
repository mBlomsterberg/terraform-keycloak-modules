################################################################################
# Keycloak identity providers wrapper — outputs
################################################################################

output "wrapper" {
  description = "Map of all managed identity provider module instances, keyed by the same key used in var.items."
  value       = module.identity_provider
}

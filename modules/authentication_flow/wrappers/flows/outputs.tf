################################################################################
# Keycloak authentication flows wrapper — outputs
################################################################################

output "wrapper" {
  description = "Map of all managed authentication flow module instances, keyed by the same key used in var.items."
  value       = module.flow
}

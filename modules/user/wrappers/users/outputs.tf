################################################################################
# Keycloak users wrapper — outputs
################################################################################

output "wrapper" {
  description = "Map of all managed user module instances, keyed by the same key used in var.items."
  value       = module.user
  sensitive   = true
}

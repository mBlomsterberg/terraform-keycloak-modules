################################################################################
# Keycloak organizations wrapper — outputs
################################################################################

output "wrapper" {
  description = "Map of all managed organization module instances, keyed by the same key used in var.items."
  value       = module.organization
}

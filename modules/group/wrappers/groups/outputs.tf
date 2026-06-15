################################################################################
# Keycloak groups wrapper — outputs
################################################################################

output "wrapper" {
  description = "Map of all managed group module instances, keyed by the same key used in var.items."
  value       = module.group
}

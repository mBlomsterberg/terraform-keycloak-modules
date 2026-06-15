################################################################################
# Keycloak realms wrapper — outputs
################################################################################

output "realms" {
  description = "All managed realms keyed by their logical map key."
  value = {
    for k, m in module.realm : k => {
      id             = m.id
      realm          = m.realm
      enabled        = m.enabled
      events_managed = m.events_managed
    }
  }
}

output "realm_ids" {
  description = "Map of logical key => realm internal ID (equal to the realm name)."
  value       = { for k, m in module.realm : k => m.id }
}

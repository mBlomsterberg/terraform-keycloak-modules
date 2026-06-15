################################################################################
# Keycloak roles wrapper — outputs
################################################################################

output "roles" {
  description = "All managed roles keyed by their logical map key."
  value = {
    for k, m in module.role : k => {
      id        = m.id
      name      = m.name
      client_id = m.client_id
    }
  }
}

output "role_ids" {
  description = "Map of logical key => Keycloak internal role UUID."
  value       = { for k, m in module.role : k => m.id }
}

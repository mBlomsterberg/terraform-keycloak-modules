################################################################################
# Keycloak OpenID clients wrapper — outputs
################################################################################

output "clients" {
  description = "All managed clients keyed by their logical map key."
  value = {
    for k, m in module.client : k => {
      id                      = m.id
      client_id               = m.client_id
      service_account_user_id = m.service_account_user_id
      resource_server_id      = m.resource_server_id
    }
  }
}

output "client_ids" {
  description = "Map of logical key => Keycloak internal client UUID."
  value       = { for k, m in module.client : k => m.id }
}

output "service_account_user_ids" {
  description = "Map of logical key => service-account user ID (only set when service_accounts_enabled = true)."
  value       = { for k, m in module.client : k => m.service_account_user_id }
}

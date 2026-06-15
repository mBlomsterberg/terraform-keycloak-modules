################################################################################
# Standalone Keycloak OpenID client module — outputs
################################################################################

output "id" {
  description = "Internal Keycloak UUID of the client."
  value       = keycloak_openid_client.this.id
}

output "client_id" {
  description = "The client identifier registered in Keycloak."
  value       = keycloak_openid_client.this.client_id
}

output "service_account_user_id" {
  description = "Service-account user ID (only set when service_accounts_enabled = true)."
  value       = keycloak_openid_client.this.service_account_user_id
}

output "resource_server_id" {
  description = "Resource-server ID (set when authorization services are enabled)."
  value       = keycloak_openid_client.this.resource_server_id
}

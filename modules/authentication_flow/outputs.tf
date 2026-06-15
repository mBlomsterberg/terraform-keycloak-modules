output "id" {
  description = "Internal Keycloak UUID of the authentication flow."
  value       = try(keycloak_authentication_flow.this[0].id, null)
}

output "alias" {
  description = "Alias of the authentication flow — use this as parent_flow_alias when adding executions or subflows outside the module."
  value       = try(keycloak_authentication_flow.this[0].alias, null)
}

output "execution_ids" {
  description = "Map of logical execution key => Keycloak execution UUID."
  value       = { for k, v in keycloak_authentication_execution.this : k => v.id }
}

output "subflow_ids" {
  description = "Map of logical subflow key => Keycloak subflow UUID."
  value       = { for k, v in keycloak_authentication_subflow.this : k => v.id }
}

output "execution_config_ids" {
  description = "Map of logical execution key => execution config UUID. Only populated for executions that carry a config block."
  value       = { for k, v in keycloak_authentication_execution_config.this : k => v.id }
}

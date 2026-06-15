output "browser_flow_id" {
  description = "Internal Keycloak UUID of the custom browser authentication flow."
  value       = module.browser_flow.id
}

output "browser_flow_alias" {
  description = "Alias of the custom browser flow (used when binding to realm or client overrides)."
  value       = module.browser_flow.alias
}

output "direct_grant_flow_id" {
  description = "Internal Keycloak UUID of the custom direct-grant flow."
  value       = module.direct_grant_flow.id
}

output "client_flow_id" {
  description = "Internal Keycloak UUID of the custom client authentication flow."
  value       = module.client_flow.id
}

output "browser_execution_ids" {
  description = "Map of logical key => execution UUID for all browser-flow executions."
  value       = module.browser_flow.execution_ids
}

output "browser_subflow_ids" {
  description = "Map of logical key => subflow UUID for all browser-flow subflows."
  value       = module.browser_flow.subflow_ids
}

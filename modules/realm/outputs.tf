################################################################################
# Standalone Keycloak realm module — outputs
################################################################################

output "id" {
  description = "Internal ID of the realm (equal to the realm name). Pass this as realm_id to client/role/scope modules."
  value       = keycloak_realm.this.id
}

output "realm" {
  description = "The realm name."
  value       = keycloak_realm.this.realm
}

output "enabled" {
  description = "Whether the realm is enabled."
  value       = keycloak_realm.this.enabled
}

output "events_managed" {
  description = "Whether this module manages the realm's event configuration."
  value       = var.create_events
}

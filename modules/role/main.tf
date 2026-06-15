################################################################################
# Standalone Keycloak role module
# Provider: keycloak/keycloak >= 5.7.0
#
# Manages a single keycloak_role — either a realm role (client_id = null) or a
# client role (client_id set). Realm membership is injected via var.realm_id so
# the module is decoupled from realm state and reusable across every realm. Use
# ../roles to manage many roles (and their composite relationships) from a map.
################################################################################

resource "keycloak_role" "this" {
  realm_id    = var.realm_id
  client_id   = var.client_id
  name        = var.name
  description = var.description

  # Composite roles are referenced by their already-resolved Keycloak role IDs.
  # The ../roles wrapper lets you reference sibling roles by map key instead.
  composite_roles = var.composite_roles

  attributes = var.attributes
}

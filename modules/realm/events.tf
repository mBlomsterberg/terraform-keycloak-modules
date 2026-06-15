################################################################################
# Realm event configuration (optional)
#
# keycloak_realm_events is a separate, singleton resource keyed to the realm.
# It is gated behind var.create_events so realms that don't need custom event
# logging don't manage (and reset) the realm's event settings.
################################################################################

resource "keycloak_realm_events" "this" {
  count = var.create_events ? 1 : 0

  realm_id = keycloak_realm.this.id

  events_enabled    = var.events.events_enabled
  events_expiration = var.events.events_expiration

  admin_events_enabled         = var.events.admin_events_enabled
  admin_events_details_enabled = var.events.admin_events_details_enabled

  enabled_event_types = var.events.enabled_event_types
  events_listeners    = var.events.events_listeners
}

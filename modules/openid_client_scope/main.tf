locals {
  scope_id = try(keycloak_openid_client_scope.this[0].id, null)
}

resource "keycloak_openid_client_scope" "this" {
  count = var.create ? 1 : 0

  realm_id               = var.realm_id
  name                   = var.name
  description            = var.description
  consent_screen_text    = var.consent_screen_text
  include_in_token_scope = var.include_in_token_scope
  gui_order              = var.gui_order
  extra_config           = var.extra_config
}

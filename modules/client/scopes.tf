resource "keycloak_openid_client_default_scopes" "this" {
  count = var.default_scopes != null ? 1 : 0

  realm_id       = var.realm_id
  client_id      = keycloak_openid_client.this.id
  default_scopes = var.default_scopes
}

resource "keycloak_openid_client_optional_scopes" "this" {
  count = var.optional_scopes != null ? 1 : 0

  realm_id        = var.realm_id
  client_id       = keycloak_openid_client.this.id
  optional_scopes = var.optional_scopes
}

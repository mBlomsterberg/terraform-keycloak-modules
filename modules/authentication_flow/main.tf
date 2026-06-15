resource "keycloak_authentication_flow" "this" {
  count = var.create ? 1 : 0

  realm_id    = var.realm_id
  alias       = var.alias
  description = var.description
  provider_id = var.provider_id
}

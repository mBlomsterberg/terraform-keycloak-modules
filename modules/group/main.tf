resource "keycloak_group" "this" {
  count = var.create ? 1 : 0

  realm_id        = var.realm_id
  name            = var.name
  parent_id       = var.parent_id
  organization_id = var.organization_id
  attributes      = var.attributes
}

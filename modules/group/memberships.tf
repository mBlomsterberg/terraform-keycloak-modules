resource "keycloak_group_memberships" "this" {
  count = var.create && length(var.members) > 0 ? 1 : 0

  realm_id = var.realm_id
  group_id = keycloak_group.this[0].id
  members  = var.members
}

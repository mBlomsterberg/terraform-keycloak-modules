resource "keycloak_user_groups" "this" {
  count = var.create && length(var.group_ids) > 0 ? 1 : 0

  realm_id   = var.realm_id
  user_id    = keycloak_user.this[0].id
  group_ids  = var.group_ids
  exhaustive = var.groups_exhaustive
}

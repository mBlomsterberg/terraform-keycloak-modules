resource "keycloak_group_roles" "this" {
  count = var.create && length(var.role_ids) > 0 ? 1 : 0

  realm_id   = var.realm_id
  group_id   = keycloak_group.this[0].id
  role_ids   = var.role_ids
  exhaustive = var.roles_exhaustive
}

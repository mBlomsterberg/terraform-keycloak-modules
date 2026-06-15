resource "keycloak_user_roles" "this" {
  count = var.create && length(var.role_ids) > 0 ? 1 : 0

  realm_id   = var.realm_id
  user_id    = keycloak_user.this[0].id
  role_ids   = var.role_ids
  exhaustive = var.roles_exhaustive
}

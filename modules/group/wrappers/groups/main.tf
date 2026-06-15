################################################################################
# Keycloak groups wrapper
# Provider: keycloak/keycloak >= 5.7.0
#
# Thin fan-out over the standalone ../../ group module. Each argument resolves
# via try(each.value.X, var.defaults.X, <fallback>) so per-item values win over
# shared defaults, and the standalone module's own defaults apply last.
################################################################################

module "group" {
  source   = "../../"
  for_each = var.items

  realm_id           = var.realm_id
  name               = each.value.name
  parent_id          = try(each.value.parent_id, var.defaults.parent_id, null)
  organization_id    = try(each.value.organization_id, var.defaults.organization_id, null)
  attributes         = try(each.value.attributes, var.defaults.attributes, {})
  members            = try(each.value.members, var.defaults.members, [])
  role_ids           = try(each.value.role_ids, var.defaults.role_ids, [])
  roles_exhaustive   = try(each.value.roles_exhaustive, var.defaults.roles_exhaustive, null)
  create_permissions = try(each.value.create_permissions, var.defaults.create_permissions, null)
  permissions        = try(each.value.permissions, var.defaults.permissions, null)
}

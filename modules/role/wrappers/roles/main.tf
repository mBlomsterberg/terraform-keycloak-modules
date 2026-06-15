################################################################################
# Keycloak roles wrapper
# Provider: keycloak/keycloak >= 5.7.0
#
# Thin fan-out over the standalone ../../ role module, following the
# terraform-aws-modules wrapper convention. Each argument resolves via
# try(each.value.X, var.defaults.X, null): the per-item value wins, then the
# shared default, then null — which makes the standalone module apply its own
# default. So defaults live in one place only.
#
# Composite roles use the map KEY as the cross-reference mechanism: an entry in
# an item's `composite_roles` that matches another item's key is resolved to
# that sibling's role ID; anything else is passed through as a literal role ID.
################################################################################

module "role" {
  source   = "../../"
  for_each = var.items

  realm_id = var.realm_id

  name        = each.value.name
  client_id   = try(each.value.client_id, var.defaults.client_id, null)
  description = try(each.value.description, var.defaults.description, null)
  attributes  = try(each.value.attributes, var.defaults.attributes, null)

  # Resolve each composite entry: sibling map key → its role ID, else literal ID.
  composite_roles = length(try(each.value.composite_roles, var.defaults.composite_roles, [])) > 0 ? [
    for r in try(each.value.composite_roles, var.defaults.composite_roles, []) :
    try(module.role[r].id, r)
  ] : null
}

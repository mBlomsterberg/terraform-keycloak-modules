################################################################################
# Keycloak users wrapper
# Provider: keycloak/keycloak >= 5.7.0
#
# Thin fan-out over the standalone ../../ user module. Each argument resolves
# via try(each.value.X, var.defaults.X, <fallback>) so per-item values win over
# shared defaults, and the standalone module's own defaults apply last.
################################################################################

module "user" {
  source   = "../../"
  for_each = var.items

  realm_id             = var.realm_id
  username             = each.value.username
  enabled              = try(each.value.enabled, var.defaults.enabled, null)
  email                = try(each.value.email, var.defaults.email, null)
  email_verified       = try(each.value.email_verified, var.defaults.email_verified, null)
  first_name           = try(each.value.first_name, var.defaults.first_name, null)
  last_name            = try(each.value.last_name, var.defaults.last_name, null)
  attributes           = try(each.value.attributes, var.defaults.attributes, {})
  required_actions     = try(each.value.required_actions, var.defaults.required_actions, [])
  import_existing      = try(each.value.import_existing, var.defaults.import_existing, null)
  initial_password     = try(each.value.initial_password, var.defaults.initial_password, null)
  federated_identities = try(each.value.federated_identities, var.defaults.federated_identities, {})
  group_ids            = try(each.value.group_ids, var.defaults.group_ids, [])
  groups_exhaustive    = try(each.value.groups_exhaustive, var.defaults.groups_exhaustive, null)
  role_ids             = try(each.value.role_ids, var.defaults.role_ids, [])
  roles_exhaustive     = try(each.value.roles_exhaustive, var.defaults.roles_exhaustive, null)
}

################################################################################
# Keycloak OpenID client scopes wrapper
# Provider: keycloak/keycloak >= 5.7.0
#
# Thin fan-out over the standalone ../../ openid_client_scope module. Each
# argument resolves via try(each.value.X, var.defaults.X, <fallback>) so
# per-item values win over shared defaults, and the module's own defaults last.
################################################################################

module "scope" {
  source   = "../../"
  for_each = var.items

  realm_id               = var.realm_id
  name                   = each.value.name
  description            = try(each.value.description, var.defaults.description, null)
  consent_screen_text    = try(each.value.consent_screen_text, var.defaults.consent_screen_text, null)
  include_in_token_scope = try(each.value.include_in_token_scope, var.defaults.include_in_token_scope, null)
  gui_order              = try(each.value.gui_order, var.defaults.gui_order, null)
  extra_config           = try(each.value.extra_config, var.defaults.extra_config, {})

  user_attribute_mappers   = try(each.value.user_attribute_mappers, var.defaults.user_attribute_mappers, {})
  user_property_mappers    = try(each.value.user_property_mappers, var.defaults.user_property_mappers, {})
  group_membership_mappers = try(each.value.group_membership_mappers, var.defaults.group_membership_mappers, {})
  user_realm_role_mappers  = try(each.value.user_realm_role_mappers, var.defaults.user_realm_role_mappers, {})
  user_client_role_mappers = try(each.value.user_client_role_mappers, var.defaults.user_client_role_mappers, {})
  audience_mappers         = try(each.value.audience_mappers, var.defaults.audience_mappers, {})
  hardcoded_claim_mappers  = try(each.value.hardcoded_claim_mappers, var.defaults.hardcoded_claim_mappers, {})
  full_name_mappers        = try(each.value.full_name_mappers, var.defaults.full_name_mappers, {})
}

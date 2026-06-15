################################################################################
# Keycloak identity providers wrapper
# Provider: keycloak/keycloak >= 5.7.0
#
# Thin fan-out over the standalone ../../ identity_provider module. Each
# argument resolves via try(each.value.X, var.defaults.X, <fallback>) so
# per-item values win over shared defaults, and the module's own defaults
# apply last.
################################################################################

module "identity_provider" {
  source   = "../../"
  for_each = var.items

  realm_id = var.realm_id

  # Required per item
  alias             = each.value.alias
  authorization_url = each.value.authorization_url
  client_id         = each.value.client_id
  token_url         = each.value.token_url

  # Common optional fields
  display_name                    = try(each.value.display_name, var.defaults.display_name, null)
  enabled                         = try(each.value.enabled, var.defaults.enabled, true)
  link_only                       = try(each.value.link_only, var.defaults.link_only, false)
  hide_on_login_page              = try(each.value.hide_on_login_page, var.defaults.hide_on_login_page, false)
  store_token                     = try(each.value.store_token, var.defaults.store_token, true)
  add_read_token_role_on_create   = try(each.value.add_read_token_role_on_create, var.defaults.add_read_token_role_on_create, false)
  trust_email                     = try(each.value.trust_email, var.defaults.trust_email, false)
  first_broker_login_flow_alias   = try(each.value.first_broker_login_flow_alias, var.defaults.first_broker_login_flow_alias, null)
  post_broker_login_flow_alias    = try(each.value.post_broker_login_flow_alias, var.defaults.post_broker_login_flow_alias, null)
  sync_mode                       = try(each.value.sync_mode, var.defaults.sync_mode, null)
  organization_id                 = try(each.value.organization_id, var.defaults.organization_id, null)
  org_domain                      = try(each.value.org_domain, var.defaults.org_domain, null)
  org_redirect_mode_email_matches = try(each.value.org_redirect_mode_email_matches, var.defaults.org_redirect_mode_email_matches, null)
  gui_order                       = try(each.value.gui_order, var.defaults.gui_order, null)
  extra_config                    = try(each.value.extra_config, var.defaults.extra_config, {})

  # OIDC-specific optional fields
  provider_id                             = try(each.value.provider_id, var.defaults.provider_id, "oidc")
  client_secret                           = try(each.value.client_secret, var.defaults.client_secret, null)
  client_secret_wo                        = try(each.value.client_secret_wo, var.defaults.client_secret_wo, null)
  client_secret_wo_version                = try(each.value.client_secret_wo_version, var.defaults.client_secret_wo_version, null)
  user_info_url                           = try(each.value.user_info_url, var.defaults.user_info_url, null)
  jwks_url                                = try(each.value.jwks_url, var.defaults.jwks_url, null)
  issuer                                  = try(each.value.issuer, var.defaults.issuer, null)
  logout_url                              = try(each.value.logout_url, var.defaults.logout_url, null)
  disable_user_info                       = try(each.value.disable_user_info, var.defaults.disable_user_info, false)
  default_scopes                          = try(each.value.default_scopes, var.defaults.default_scopes, null)
  validate_signature                      = try(each.value.validate_signature, var.defaults.validate_signature, false)
  disable_type_claim_check                = try(each.value.disable_type_claim_check, var.defaults.disable_type_claim_check, false)
  backchannel_supported                   = try(each.value.backchannel_supported, var.defaults.backchannel_supported, true)
  login_hint                              = try(each.value.login_hint, var.defaults.login_hint, null)
  ui_locales                              = try(each.value.ui_locales, var.defaults.ui_locales, false)
  accepts_prompt_none_forward_from_client = try(each.value.accepts_prompt_none_forward_from_client, var.defaults.accepts_prompt_none_forward_from_client, false)

  # Mappers
  attribute_importer_mappers     = try(each.value.attribute_importer_mappers, var.defaults.attribute_importer_mappers, {})
  attribute_to_role_mappers      = try(each.value.attribute_to_role_mappers, var.defaults.attribute_to_role_mappers, {})
  hardcoded_role_mappers         = try(each.value.hardcoded_role_mappers, var.defaults.hardcoded_role_mappers, {})
  hardcoded_attribute_mappers    = try(each.value.hardcoded_attribute_mappers, var.defaults.hardcoded_attribute_mappers, {})
  hardcoded_group_mappers        = try(each.value.hardcoded_group_mappers, var.defaults.hardcoded_group_mappers, {})
  user_template_importer_mappers = try(each.value.user_template_importer_mappers, var.defaults.user_template_importer_mappers, {})
  custom_mappers                 = try(each.value.custom_mappers, var.defaults.custom_mappers, {})
}

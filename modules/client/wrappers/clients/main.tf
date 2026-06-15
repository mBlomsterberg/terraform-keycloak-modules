################################################################################
# Keycloak OpenID clients wrapper
# Provider: keycloak/keycloak >= 5.7.0
#
# Thin fan-out over the standalone ../../ client module, following the
# terraform-aws-modules wrapper convention. Each argument resolves via
# try(each.value.X, var.defaults.X, null): the per-item value wins, then the
# shared default, then null — which makes the standalone module apply its own
# (secure) default. So defaults live in one place only.
################################################################################

module "client" {
  source   = "../../"
  for_each = var.items

  realm_id = var.realm_id

  client_id   = each.value.client_id
  name        = try(each.value.name, var.defaults.name, null)
  description = try(each.value.description, var.defaults.description, null)
  enabled     = try(each.value.enabled, var.defaults.enabled, null)

  access_type   = try(each.value.access_type, var.defaults.access_type, null)
  client_secret = try(each.value.client_secret, var.defaults.client_secret, null)

  standard_flow_enabled                     = try(each.value.standard_flow_enabled, var.defaults.standard_flow_enabled, null)
  implicit_flow_enabled                     = try(each.value.implicit_flow_enabled, var.defaults.implicit_flow_enabled, null)
  direct_access_grants_enabled              = try(each.value.direct_access_grants_enabled, var.defaults.direct_access_grants_enabled, null)
  service_accounts_enabled                  = try(each.value.service_accounts_enabled, var.defaults.service_accounts_enabled, null)
  oauth2_device_authorization_grant_enabled = try(each.value.oauth2_device_authorization_grant_enabled, var.defaults.oauth2_device_authorization_grant_enabled, null)

  valid_redirect_uris             = try(each.value.valid_redirect_uris, var.defaults.valid_redirect_uris, null)
  valid_post_logout_redirect_uris = try(each.value.valid_post_logout_redirect_uris, var.defaults.valid_post_logout_redirect_uris, null)
  web_origins                     = try(each.value.web_origins, var.defaults.web_origins, null)
  root_url                        = try(each.value.root_url, var.defaults.root_url, null)
  base_url                        = try(each.value.base_url, var.defaults.base_url, null)
  admin_url                       = try(each.value.admin_url, var.defaults.admin_url, null)

  pkce_code_challenge_method = try(each.value.pkce_code_challenge_method, var.defaults.pkce_code_challenge_method, null)
  require_dpop_bound_tokens  = try(each.value.require_dpop_bound_tokens, var.defaults.require_dpop_bound_tokens, null)

  access_token_lifespan               = try(each.value.access_token_lifespan, var.defaults.access_token_lifespan, null)
  client_session_idle_timeout         = try(each.value.client_session_idle_timeout, var.defaults.client_session_idle_timeout, null)
  client_session_max_lifespan         = try(each.value.client_session_max_lifespan, var.defaults.client_session_max_lifespan, null)
  client_offline_session_idle_timeout = try(each.value.client_offline_session_idle_timeout, var.defaults.client_offline_session_idle_timeout, null)
  client_offline_session_max_lifespan = try(each.value.client_offline_session_max_lifespan, var.defaults.client_offline_session_max_lifespan, null)

  login_theme                         = try(each.value.login_theme, var.defaults.login_theme, null)
  frontchannel_logout_enabled         = try(each.value.frontchannel_logout_enabled, var.defaults.frontchannel_logout_enabled, null)
  backchannel_logout_url              = try(each.value.backchannel_logout_url, var.defaults.backchannel_logout_url, null)
  backchannel_logout_session_required = try(each.value.backchannel_logout_session_required, var.defaults.backchannel_logout_session_required, null)

  authentication_flow_binding_overrides = try(each.value.authentication_flow_binding_overrides, var.defaults.authentication_flow_binding_overrides, null)

  extra_config = try(each.value.extra_config, var.defaults.extra_config, null)

  default_scopes  = try(each.value.default_scopes, var.defaults.default_scopes, null)
  optional_scopes = try(each.value.optional_scopes, var.defaults.optional_scopes, null)
}

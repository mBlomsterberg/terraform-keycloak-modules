################################################################################
# Standalone Keycloak OpenID client module
# Provider: keycloak/keycloak >= 5.7.0
#
# Manages a single keycloak_openid_client. Realm membership is injected via
# var.realm_id so the module is decoupled from realm state and reusable across
# every realm. Use ../clients to manage many clients from a single map.
################################################################################

resource "keycloak_openid_client" "this" {
  realm_id    = var.realm_id
  client_id   = var.client_id
  name        = var.name
  description = var.description
  enabled     = var.enabled

  access_type   = var.access_type
  client_secret = var.client_secret

  # ── Flows ──────────────────────────────────────────────────────────────────
  standard_flow_enabled                     = var.standard_flow_enabled
  implicit_flow_enabled                     = var.implicit_flow_enabled
  direct_access_grants_enabled              = var.direct_access_grants_enabled
  service_accounts_enabled                  = var.service_accounts_enabled
  oauth2_device_authorization_grant_enabled = var.oauth2_device_authorization_grant_enabled

  # ── URIs ───────────────────────────────────────────────────────────────────
  valid_redirect_uris             = var.valid_redirect_uris
  valid_post_logout_redirect_uris = var.valid_post_logout_redirect_uris
  web_origins                     = var.web_origins
  root_url                        = var.root_url
  base_url                        = var.base_url
  admin_url                       = var.admin_url

  # ── PKCE & DPoP ──────────────────────────────────────────────────────────────
  pkce_code_challenge_method = var.pkce_code_challenge_method
  require_dpop_bound_tokens  = var.require_dpop_bound_tokens

  # ── Token / session settings ─────────────────────────────────────────────────
  access_token_lifespan               = var.access_token_lifespan
  client_session_idle_timeout         = var.client_session_idle_timeout
  client_session_max_lifespan         = var.client_session_max_lifespan
  client_offline_session_idle_timeout = var.client_offline_session_idle_timeout
  client_offline_session_max_lifespan = var.client_offline_session_max_lifespan

  # ── Login / logout ────────────────────────────────────────────────────────────
  login_theme                         = var.login_theme
  frontchannel_logout_enabled         = var.frontchannel_logout_enabled
  backchannel_logout_url              = var.backchannel_logout_url
  backchannel_logout_session_required = var.backchannel_logout_session_required

  extra_config = var.extra_config

  dynamic "authentication_flow_binding_overrides" {
    for_each = var.authentication_flow_binding_overrides != null ? [var.authentication_flow_binding_overrides] : []
    content {
      browser_id      = authentication_flow_binding_overrides.value.browser_id
      direct_grant_id = authentication_flow_binding_overrides.value.direct_grant_id
    }
  }
}

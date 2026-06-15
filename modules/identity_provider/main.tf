locals {
  idp_alias = try(keycloak_oidc_identity_provider.this[0].alias, null)
}

resource "keycloak_oidc_identity_provider" "this" {
  count = var.create ? 1 : 0

  realm                                   = var.realm_id
  alias                                   = var.alias
  display_name                            = var.display_name
  enabled                                 = var.enabled
  link_only                               = var.link_only
  hide_on_login_page                      = var.hide_on_login_page
  store_token                             = var.store_token
  add_read_token_role_on_create           = var.add_read_token_role_on_create
  trust_email                             = var.trust_email
  first_broker_login_flow_alias           = var.first_broker_login_flow_alias
  post_broker_login_flow_alias            = var.post_broker_login_flow_alias
  sync_mode                               = var.sync_mode
  provider_id                             = var.provider_id
  authorization_url                       = var.authorization_url
  client_id                               = var.client_id
  client_secret                           = var.client_secret
  client_secret_wo                        = var.client_secret_wo
  client_secret_wo_version                = var.client_secret_wo_version
  token_url                               = var.token_url
  user_info_url                           = var.user_info_url
  jwks_url                                = var.jwks_url
  issuer                                  = var.issuer
  logout_url                              = var.logout_url
  disable_user_info                       = var.disable_user_info
  default_scopes                          = var.default_scopes
  validate_signature                      = var.validate_signature
  disable_type_claim_check                = var.disable_type_claim_check
  backchannel_supported                   = var.backchannel_supported
  login_hint                              = var.login_hint
  ui_locales                              = var.ui_locales
  accepts_prompt_none_forward_from_client = var.accepts_prompt_none_forward_from_client
  organization_id                         = var.organization_id
  org_domain                              = var.org_domain
  org_redirect_mode_email_matches         = var.org_redirect_mode_email_matches
  gui_order                               = var.gui_order
  extra_config                            = var.extra_config
}

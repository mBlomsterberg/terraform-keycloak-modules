locals {
  idp_alias = try(keycloak_oidc_github_identity_provider.this[0].alias, null)
}

resource "keycloak_oidc_github_identity_provider" "this" {
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
  client_id                               = var.client_id
  client_secret                           = var.client_secret
  client_secret_wo                        = var.client_secret_wo
  client_secret_wo_version                = var.client_secret_wo_version
  disable_user_info                       = var.disable_user_info
  default_scopes                          = var.default_scopes
  login_hint                              = var.login_hint
  accepts_prompt_none_forward_from_client = var.accepts_prompt_none_forward_from_client
  organization_id                         = var.organization_id
  org_domain                              = var.org_domain
  org_redirect_mode_email_matches         = var.org_redirect_mode_email_matches
  gui_order                               = var.gui_order
  extra_config                            = var.extra_config
  base_url                                = var.base_url
  api_url                                 = var.api_url
  github_json_format                      = var.github_json_format
}

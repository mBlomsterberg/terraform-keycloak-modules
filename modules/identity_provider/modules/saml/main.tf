locals {
  idp_alias = try(keycloak_saml_identity_provider.this[0].alias, null)
}

resource "keycloak_saml_identity_provider" "this" {
  count = var.create ? 1 : 0

  realm                                  = var.realm_id
  alias                                  = var.alias
  display_name                           = var.display_name
  enabled                                = var.enabled
  link_only                              = var.link_only
  hide_on_login_page                     = var.hide_on_login_page
  store_token                            = var.store_token
  add_read_token_role_on_create          = var.add_read_token_role_on_create
  trust_email                            = var.trust_email
  first_broker_login_flow_alias          = var.first_broker_login_flow_alias
  post_broker_login_flow_alias           = var.post_broker_login_flow_alias
  sync_mode                              = var.sync_mode
  organization_id                        = var.organization_id
  org_domain                             = var.org_domain
  org_redirect_mode_email_matches        = var.org_redirect_mode_email_matches
  gui_order                              = var.gui_order
  extra_config                           = var.extra_config
  entity_id                              = var.entity_id
  single_sign_on_service_url             = var.single_sign_on_service_url
  single_logout_service_url              = var.single_logout_service_url
  backchannel_supported                  = var.backchannel_supported
  name_id_policy_format                  = var.name_id_policy_format
  post_binding_response                  = var.post_binding_response
  post_binding_authn_request             = var.post_binding_authn_request
  post_binding_logout                    = var.post_binding_logout
  want_assertions_signed                 = var.want_assertions_signed
  want_assertions_encrypted              = var.want_assertions_encrypted
  want_authn_requests_signed             = var.want_authn_requests_signed
  force_authn                            = var.force_authn
  validate_signature                     = var.validate_signature
  signing_certificate                    = var.signing_certificate
  signature_algorithm                    = var.signature_algorithm
  xml_sign_key_info_key_name_transformer = var.xml_sign_key_info_key_name_transformer
  principal_type                         = var.principal_type
  principal_attribute                    = var.principal_attribute
  authn_context_class_refs               = var.authn_context_class_refs
  authn_context_decl_refs                = var.authn_context_decl_refs
  authn_context_comparison_type          = var.authn_context_comparison_type
  authenticate_by_default                = var.authenticate_by_default
  provider_id                            = var.provider_id
}

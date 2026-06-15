################################################################################
# Keycloak realms wrapper
# Provider: keycloak/keycloak >= 5.7.0
#
# Thin fan-out over the standalone ../../ realm module, following the
# terraform-aws-modules wrapper convention. Each argument resolves via
# try(each.value.X, var.defaults.X, null): the per-item value wins, then the
# shared default, then null — which makes the standalone module apply its own
# (secure) default. So defaults live in one place only.
################################################################################

module "realm" {
  source   = "../../"
  for_each = var.items

  realm             = each.value.realm
  enabled           = try(each.value.enabled, var.defaults.enabled, null)
  display_name      = try(each.value.display_name, var.defaults.display_name, null)
  display_name_html = try(each.value.display_name_html, var.defaults.display_name_html, null)

  user_managed_access = try(each.value.user_managed_access, var.defaults.user_managed_access, null)
  attributes          = try(each.value.attributes, var.defaults.attributes, null)

  registration_allowed           = try(each.value.registration_allowed, var.defaults.registration_allowed, null)
  registration_email_as_username = try(each.value.registration_email_as_username, var.defaults.registration_email_as_username, null)
  edit_username_allowed          = try(each.value.edit_username_allowed, var.defaults.edit_username_allowed, null)
  reset_password_allowed         = try(each.value.reset_password_allowed, var.defaults.reset_password_allowed, null)
  remember_me                    = try(each.value.remember_me, var.defaults.remember_me, null)
  verify_email                   = try(each.value.verify_email, var.defaults.verify_email, null)
  login_with_email_allowed       = try(each.value.login_with_email_allowed, var.defaults.login_with_email_allowed, null)
  duplicate_emails_allowed       = try(each.value.duplicate_emails_allowed, var.defaults.duplicate_emails_allowed, null)
  ssl_required                   = try(each.value.ssl_required, var.defaults.ssl_required, null)

  login_theme   = try(each.value.login_theme, var.defaults.login_theme, null)
  account_theme = try(each.value.account_theme, var.defaults.account_theme, null)
  admin_theme   = try(each.value.admin_theme, var.defaults.admin_theme, null)
  email_theme   = try(each.value.email_theme, var.defaults.email_theme, null)

  default_signature_algorithm = try(each.value.default_signature_algorithm, var.defaults.default_signature_algorithm, null)
  revoke_refresh_token        = try(each.value.revoke_refresh_token, var.defaults.revoke_refresh_token, null)
  refresh_token_max_reuse     = try(each.value.refresh_token_max_reuse, var.defaults.refresh_token_max_reuse, null)

  sso_session_idle_timeout             = try(each.value.sso_session_idle_timeout, var.defaults.sso_session_idle_timeout, null)
  sso_session_max_lifespan             = try(each.value.sso_session_max_lifespan, var.defaults.sso_session_max_lifespan, null)
  sso_session_idle_timeout_remember_me = try(each.value.sso_session_idle_timeout_remember_me, var.defaults.sso_session_idle_timeout_remember_me, null)
  sso_session_max_lifespan_remember_me = try(each.value.sso_session_max_lifespan_remember_me, var.defaults.sso_session_max_lifespan_remember_me, null)
  offline_session_idle_timeout         = try(each.value.offline_session_idle_timeout, var.defaults.offline_session_idle_timeout, null)
  offline_session_max_lifespan         = try(each.value.offline_session_max_lifespan, var.defaults.offline_session_max_lifespan, null)
  offline_session_max_lifespan_enabled = try(each.value.offline_session_max_lifespan_enabled, var.defaults.offline_session_max_lifespan_enabled, null)

  access_token_lifespan                    = try(each.value.access_token_lifespan, var.defaults.access_token_lifespan, null)
  access_token_lifespan_for_implicit_flow  = try(each.value.access_token_lifespan_for_implicit_flow, var.defaults.access_token_lifespan_for_implicit_flow, null)
  access_code_lifespan                     = try(each.value.access_code_lifespan, var.defaults.access_code_lifespan, null)
  access_code_lifespan_login               = try(each.value.access_code_lifespan_login, var.defaults.access_code_lifespan_login, null)
  access_code_lifespan_user_action         = try(each.value.access_code_lifespan_user_action, var.defaults.access_code_lifespan_user_action, null)
  action_token_generated_by_user_lifespan  = try(each.value.action_token_generated_by_user_lifespan, var.defaults.action_token_generated_by_user_lifespan, null)
  action_token_generated_by_admin_lifespan = try(each.value.action_token_generated_by_admin_lifespan, var.defaults.action_token_generated_by_admin_lifespan, null)
  oauth2_device_code_lifespan              = try(each.value.oauth2_device_code_lifespan, var.defaults.oauth2_device_code_lifespan, null)
  oauth2_device_polling_interval           = try(each.value.oauth2_device_polling_interval, var.defaults.oauth2_device_polling_interval, null)

  password_policy = try(each.value.password_policy, var.defaults.password_policy, null)

  default_default_client_scopes  = try(each.value.default_default_client_scopes, var.defaults.default_default_client_scopes, null)
  default_optional_client_scopes = try(each.value.default_optional_client_scopes, var.defaults.default_optional_client_scopes, null)

  smtp_server          = try(each.value.smtp_server, var.defaults.smtp_server, null)
  internationalization = try(each.value.internationalization, var.defaults.internationalization, null)
  security_defenses    = try(each.value.security_defenses, var.defaults.security_defenses, null)

  create_events = try(each.value.create_events, var.defaults.create_events, false)
  events        = try(each.value.events, var.defaults.events, {})
}

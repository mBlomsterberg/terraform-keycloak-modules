################################################################################
# Standalone Keycloak realm module
# Provider: keycloak/keycloak >= 5.7.0
#
# Manages a single keycloak_realm and (optionally) its realm-wide event config.
# Use ../realms to manage many realms from a single map.
################################################################################

resource "keycloak_realm" "this" {
  realm             = var.realm
  enabled           = var.enabled
  display_name      = var.display_name
  display_name_html = var.display_name_html

  user_managed_access = var.user_managed_access
  attributes          = var.attributes

  # ── Login settings ─────────────────────────────────────────────────────────
  registration_allowed           = var.registration_allowed
  registration_email_as_username = var.registration_email_as_username
  edit_username_allowed          = var.edit_username_allowed
  reset_password_allowed         = var.reset_password_allowed
  remember_me                    = var.remember_me
  verify_email                   = var.verify_email
  login_with_email_allowed       = var.login_with_email_allowed
  duplicate_emails_allowed       = var.duplicate_emails_allowed
  ssl_required                   = var.ssl_required

  # ── Themes ─────────────────────────────────────────────────────────────────
  login_theme   = var.login_theme
  account_theme = var.account_theme
  admin_theme   = var.admin_theme
  email_theme   = var.email_theme

  # ── Tokens / sessions ────────────────────────────────────────────────────────
  default_signature_algorithm = var.default_signature_algorithm
  revoke_refresh_token        = var.revoke_refresh_token
  refresh_token_max_reuse     = var.refresh_token_max_reuse

  sso_session_idle_timeout             = var.sso_session_idle_timeout
  sso_session_max_lifespan             = var.sso_session_max_lifespan
  sso_session_idle_timeout_remember_me = var.sso_session_idle_timeout_remember_me
  sso_session_max_lifespan_remember_me = var.sso_session_max_lifespan_remember_me
  offline_session_idle_timeout         = var.offline_session_idle_timeout
  offline_session_max_lifespan         = var.offline_session_max_lifespan
  offline_session_max_lifespan_enabled = var.offline_session_max_lifespan_enabled

  access_token_lifespan                    = var.access_token_lifespan
  access_token_lifespan_for_implicit_flow  = var.access_token_lifespan_for_implicit_flow
  access_code_lifespan                     = var.access_code_lifespan
  access_code_lifespan_login               = var.access_code_lifespan_login
  access_code_lifespan_user_action         = var.access_code_lifespan_user_action
  action_token_generated_by_user_lifespan  = var.action_token_generated_by_user_lifespan
  action_token_generated_by_admin_lifespan = var.action_token_generated_by_admin_lifespan
  oauth2_device_code_lifespan              = var.oauth2_device_code_lifespan
  oauth2_device_polling_interval           = var.oauth2_device_polling_interval

  # ── Password policy ────────────────────────────────────────────────────────
  password_policy = var.password_policy

  # ── Default client scopes ────────────────────────────────────────────────────
  default_default_client_scopes  = var.default_default_client_scopes
  default_optional_client_scopes = var.default_optional_client_scopes

  # ── SMTP ───────────────────────────────────────────────────────────────────
  dynamic "smtp_server" {
    for_each = var.smtp_server != null ? [var.smtp_server] : []
    content {
      host                  = smtp_server.value.host
      port                  = smtp_server.value.port
      from                  = smtp_server.value.from
      from_display_name     = smtp_server.value.from_display_name
      reply_to              = smtp_server.value.reply_to
      reply_to_display_name = smtp_server.value.reply_to_display_name
      envelope_from         = smtp_server.value.envelope_from
      ssl                   = smtp_server.value.ssl
      starttls              = smtp_server.value.starttls

      dynamic "auth" {
        for_each = smtp_server.value.auth != null ? [smtp_server.value.auth] : []
        content {
          username = auth.value.username
          password = auth.value.password
        }
      }
    }
  }

  # ── Internationalization ─────────────────────────────────────────────────────
  dynamic "internationalization" {
    for_each = var.internationalization != null ? [var.internationalization] : []
    content {
      supported_locales = internationalization.value.supported_locales
      default_locale    = internationalization.value.default_locale
    }
  }

  # ── Security defenses ──────────────────────────────────────────────────────
  dynamic "security_defenses" {
    for_each = var.security_defenses != null ? [var.security_defenses] : []
    content {
      dynamic "headers" {
        for_each = security_defenses.value.headers != null ? [security_defenses.value.headers] : []
        content {
          x_frame_options                     = headers.value.x_frame_options
          content_security_policy             = headers.value.content_security_policy
          content_security_policy_report_only = headers.value.content_security_policy_report_only
          x_content_type_options              = headers.value.x_content_type_options
          x_robots_tag                        = headers.value.x_robots_tag
          x_xss_protection                    = headers.value.x_xss_protection
          strict_transport_security           = headers.value.strict_transport_security
          referrer_policy                     = headers.value.referrer_policy
        }
      }

      dynamic "brute_force_detection" {
        for_each = security_defenses.value.brute_force_detection != null ? [security_defenses.value.brute_force_detection] : []
        content {
          permanent_lockout                = brute_force_detection.value.permanent_lockout
          max_login_failures               = brute_force_detection.value.max_login_failures
          wait_increment_seconds           = brute_force_detection.value.wait_increment_seconds
          quick_login_check_milli_seconds  = brute_force_detection.value.quick_login_check_milli_seconds
          minimum_quick_login_wait_seconds = brute_force_detection.value.minimum_quick_login_wait_seconds
          max_failure_wait_seconds         = brute_force_detection.value.max_failure_wait_seconds
          failure_reset_time_seconds       = brute_force_detection.value.failure_reset_time_seconds
        }
      }
    }
  }
}

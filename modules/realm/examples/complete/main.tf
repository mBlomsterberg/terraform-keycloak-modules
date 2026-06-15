################################################################################
# Example: complete — standalone Keycloak realm module
#
# Exercises the full surface of the ../../ (standalone realm) module: login
# policy, session/token lifespans, SMTP, internationalization, security
# defenses, a password policy, and managed event logging.
################################################################################

terraform {
  required_version = ">= 1.0"

  required_providers {
    keycloak = {
      source  = "keycloak/keycloak"
      version = ">= 5.7.0"
    }
  }
}

provider "keycloak" {
  # Configured via environment variables in CI, e.g.:
  #   KEYCLOAK_URL, KEYCLOAK_CLIENT_ID, KEYCLOAK_CLIENT_SECRET
  url = "https://auth.example.com"
}

module "internal" {
  source = "../../"

  realm             = "internal"
  enabled           = true
  display_name      = "Example Internal"
  display_name_html = "<b>Example</b> Internal"

  # ── Login policy ────────────────────────────────────────────────────────────
  registration_allowed     = false
  edit_username_allowed    = false
  reset_password_allowed   = true
  remember_me              = true
  verify_email             = true
  login_with_email_allowed = true
  duplicate_emails_allowed = false
  ssl_required             = "all"

  # ── Themes ─────────────────────────────────────────────────────────────────
  login_theme   = "example"
  account_theme = "example"

  # ── Tokens / sessions ────────────────────────────────────────────────────────
  default_signature_algorithm          = "RS256"
  revoke_refresh_token                 = true
  refresh_token_max_reuse              = 0
  sso_session_idle_timeout             = "30m"
  sso_session_max_lifespan             = "10h"
  offline_session_idle_timeout         = "720h"
  offline_session_max_lifespan_enabled = true
  offline_session_max_lifespan         = "1440h"
  access_token_lifespan                = "5m"
  access_code_lifespan                 = "1m"

  password_policy = "upperCase(1) and lowerCase(1) and digits(1) and length(12) and notUsername"

  default_optional_client_scopes = ["offline_access", "microprofile-jwt"]

  smtp_server = {
    host              = "smtp.example.com"
    port              = "587"
    from              = "no-reply@example.com"
    from_display_name = "Example"
    starttls          = true
    auth = {
      username = "smtp-user"
      password = "change-me-via-tfvars"
    }
  }

  internationalization = {
    supported_locales = ["en", "da", "de"]
    default_locale    = "en"
  }

  security_defenses = {
    headers = {
      x_frame_options           = "SAMEORIGIN"
      content_security_policy   = "frame-src 'self'; frame-ancestors 'self'; object-src 'none';"
      x_content_type_options    = "nosniff"
      strict_transport_security = "max-age=31536000; includeSubDomains"
      referrer_policy           = "no-referrer"
    }
    brute_force_detection = {
      permanent_lockout        = false
      max_login_failures       = 20
      wait_increment_seconds   = 60
      max_failure_wait_seconds = 900
    }
  }

  # ── Event logging ─────────────────────────────────────────────────────────
  create_events = true
  events = {
    events_enabled               = true
    events_expiration            = 604800
    admin_events_enabled         = true
    admin_events_details_enabled = true
    events_listeners             = ["jboss-logging"]
  }
}

output "realm_id" {
  description = "Internal ID of the internal realm; pass as realm_id to downstream modules."
  value       = module.internal.id
}

output "realm_name" {
  description = "The realm name."
  value       = module.internal.realm
}

################################################################################
# Example: complete — standalone Keycloak OpenID client module
#
# Exercises the full surface of the ../../ (standalone client) module:
# a confidential web client, an M2M service-account client, and a public
# device-flow client, all in one realm.
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

data "keycloak_realm" "internal" {
  realm = "internal"
}

# ── Confidential web client — every supported argument set explicitly ──────────
module "dashboard" {
  source = "../../"

  realm_id    = data.keycloak_realm.internal.id
  client_id   = "dashboard"
  name        = "Dashboard"
  description = "Internal operations dashboard."
  enabled     = true

  access_type = "CONFIDENTIAL"
  # client_secret omitted — let Keycloak generate one.

  standard_flow_enabled                     = true
  implicit_flow_enabled                     = false
  direct_access_grants_enabled              = false
  service_accounts_enabled                  = false
  oauth2_device_authorization_grant_enabled = false

  valid_redirect_uris             = ["https://app.example.com/*"]
  valid_post_logout_redirect_uris = ["https://app.example.com/goodbye"]
  web_origins                     = ["https://app.example.com"]
  root_url                        = "https://app.example.com"
  base_url                        = "/home"
  admin_url                       = "https://app.example.com"

  pkce_code_challenge_method = "S256"
  require_dpop_bound_tokens  = true

  access_token_lifespan               = "300"
  client_session_idle_timeout         = "1800"
  client_session_max_lifespan         = "36000"
  client_offline_session_idle_timeout = "2592000"
  client_offline_session_max_lifespan = "5184000"

  login_theme                         = "example"
  frontchannel_logout_enabled         = true
  backchannel_logout_url              = "https://app.example.com/logout"
  backchannel_logout_session_required = true

  extra_config = {
    "post.logout.redirect.uris" = "+"
  }

  default_scopes  = ["openid", "profile", "email", "roles"]
  optional_scopes = ["offline_access", "groups"]
}

# ── Machine-to-machine client — client_credentials only ────────────────────────
module "billing_worker" {
  source = "../../"

  realm_id    = data.keycloak_realm.internal.id
  client_id   = "billing-worker"
  name        = "Billing Worker"
  description = "Backend service issuing M2M tokens via client_credentials."

  access_type              = "CONFIDENTIAL"
  standard_flow_enabled    = false
  service_accounts_enabled = true
}

# ── Public device-flow client (e.g. TV dashboard) ──────────────────────────────
module "dashboard_tv" {
  source = "../../"

  realm_id  = data.keycloak_realm.internal.id
  client_id = "dashboard-tv"
  name      = "TV Dashboard"

  access_type                               = "PUBLIC"
  standard_flow_enabled                     = false
  oauth2_device_authorization_grant_enabled = true
}

output "dashboard_id" {
  description = "Internal Keycloak UUID of the dashboard client."
  value       = module.dashboard.id
}

output "billing_worker_service_account_user_id" {
  description = "Service-account user ID for the M2M billing worker."
  value       = module.billing_worker.service_account_user_id
}

output "dashboard_tv_client_id" {
  description = "Registered client identifier for the TV dashboard."
  value       = module.dashboard_tv.client_id
}

################################################################################
# Example: wrapper — manage many OpenID clients from one typed map
#
# Uses the ../../wrappers/clients fan-out module. Each entry falls back to the
# standalone module's secure defaults; only the fields that differ are set.
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

module "clients" {
  source = "../../wrappers/clients"

  realm_id = data.keycloak_realm.internal.id

  # Shared values applied to every item below unless overridden per entry.
  # Anything not set here still falls back to the standalone module's defaults.
  defaults = {
    login_theme     = "example"
    web_origins     = ["https://example.com"]
    extra_config    = { "frontchannel.logout.session.required" = "true" }
    default_scopes  = ["openid", "profile", "email", "roles"]
    optional_scopes = ["offline_access"]
  }

  items = {
    # Confidential web client — relies on secure defaults (CONFIDENTIAL,
    # standard flow on, S256 PKCE) plus the shared `defaults` above.
    # Overrides optional_scopes to add the groups scope.
    dashboard = {
      client_id           = "dashboard"
      name                = "Dashboard"
      valid_redirect_uris = ["https://app.example.com/*"]
      web_origins         = ["https://app.example.com"]  # overrides default
      optional_scopes     = ["offline_access", "groups"] # overrides default
    }

    # Public device-flow client — no optional scopes needed.
    dashboard_tv = {
      client_id                                 = "dashboard-tv"
      name                                      = "TV Dashboard"
      access_type                               = "PUBLIC"
      standard_flow_enabled                     = false
      oauth2_device_authorization_grant_enabled = true
    }

    # Machine-to-machine client (client_credentials) — no user scopes.
    billing_worker = {
      client_id                = "billing-worker"
      name                     = "Billing Worker"
      description              = "Backend service issuing M2M tokens."
      standard_flow_enabled    = false
      service_accounts_enabled = true
      default_scopes           = ["openid", "roles"] # narrowed — no profile/email
      optional_scopes          = []                  # no optional scopes for M2M
    }
  }
}

output "client_ids" {
  description = "Logical key => internal Keycloak client UUID."
  value       = module.clients.client_ids
}

output "service_account_user_ids" {
  description = "Logical key => service-account user ID (set only for M2M clients)."
  value       = module.clients.service_account_user_ids
}

output "clients" {
  description = "Full map of managed clients."
  value       = module.clients.clients
}

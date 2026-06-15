################################################################################
# Example: complete — Keycloak authentication flow module
#
# Creates three custom authentication flows to replace Keycloak's built-in
# browser, direct-grant, and service-account (client) flows:
#
#   browser_flow        — cookie → IdP redirector (with config) → conditional OTP
#   direct_grant_flow   — username/password only, no OTP
#   client_flow         — client-secret authenticator
################################################################################

terraform {
  required_version = ">= 1.3"

  required_providers {
    keycloak = {
      source  = "keycloak/keycloak"
      version = ">= 5.7.0"
    }
  }
}

provider "keycloak" {
  # Configured via environment variables:
  #   KEYCLOAK_URL, KEYCLOAK_CLIENT_ID, KEYCLOAK_CLIENT_SECRET
  url = "https://auth.example.com"
}

data "keycloak_realm" "this" {
  realm = "my-realm"
}

# ── Custom browser flow ────────────────────────────────────────────────────────
# Mirrors the built-in browser flow but adds an IdP redirector with a default
# provider and a conditional OTP subflow.

module "browser_flow" {
  source = "../../"

  realm_id    = data.keycloak_realm.this.id
  alias       = "custom-browser"
  description = "Custom browser flow: cookie, IdP redirect, conditional OTP."
  provider_id = "basic-flow"

  executions = {
    cookie = {
      authenticator = "auth-cookie"
      requirement   = "ALTERNATIVE"
      priority      = 10
    }

    identity_provider_redirector = {
      authenticator = "identity-provider-redirector"
      requirement   = "ALTERNATIVE"
      priority      = 25
      config = {
        alias = "idp-redirector-config"
        config = {
          defaultProvider = "google"
        }
      }
    }
  }

  subflows = {
    conditional_otp = {
      alias       = "Browser - Conditional OTP"
      description = "Flow to conditionally challenge with OTP."
      provider_id = "basic-flow"
      requirement = "CONDITIONAL"
      priority    = 30
    }
  }
}

# ── Custom direct-grant flow ───────────────────────────────────────────────────

module "direct_grant_flow" {
  source = "../../"

  realm_id    = data.keycloak_realm.this.id
  alias       = "custom-direct-grant"
  description = "Direct-grant flow accepting username and password only."
  provider_id = "basic-flow"

  executions = {
    username_password = {
      authenticator = "direct-grant-validate-username"
      requirement   = "REQUIRED"
      priority      = 10
    }
    password = {
      authenticator = "direct-grant-validate-password"
      requirement   = "REQUIRED"
      priority      = 20
    }
  }
}

# ── Custom client (service-account) flow ──────────────────────────────────────

module "client_flow" {
  source = "../../"

  realm_id    = data.keycloak_realm.this.id
  alias       = "custom-client-auth"
  description = "Client authentication flow using client-secret only."
  provider_id = "client-flow"

  executions = {
    client_secret = {
      authenticator = "client-secret"
      requirement   = "ALTERNATIVE"
      priority      = 10
    }
  }
}

# ── Bind the custom browser flow to the realm ─────────────────────────────────

resource "keycloak_realm" "this" {
  realm   = data.keycloak_realm.this.realm
  enabled = true

  browser_flow      = module.browser_flow.alias
  direct_grant_flow = module.direct_grant_flow.alias
}

################################################################################
# Example: complete — Keycloak organization module
#
# Creates two organizations in a shared realm:
#
#   acme    — enterprise tenant with two verified domains, attributes,
#             a redirect URL, and a scoped Google IdP + admin group
#   globex  — minimal tenant with one unverified domain
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
  realm = "internal"
}

# ── ACME Corporation — full configuration ──────────────────────────────────────

module "acme" {
  source = "../../"

  realm_id     = data.keycloak_realm.this.id
  name         = "acme"
  alias        = "acme"
  enabled      = true
  description  = "ACME Corporation enterprise tenant."
  redirect_url = "https://app.example.com/welcome"

  domains = {
    "acme.com" = { verified = true }
    "acme.org" = { verified = false }
  }

  attributes = {
    tier       = "enterprise"
    managed_by = "terraform"
    region     = "eu"
  }
}

# ── Identity provider scoped to the ACME organization ─────────────────────────
# Users signing in via this Google IdP are automatically associated with ACME.

resource "keycloak_oidc_google_identity_provider" "acme_google" {
  realm         = data.keycloak_realm.this.id
  alias         = "acme-google"
  display_name  = "ACME Google"
  client_id     = "123456789-acme.apps.googleusercontent.com"
  client_secret = "super-secret-google-client-secret"

  hosted_domain   = "acme.com"
  trust_email     = true
  organization_id = module.acme.id
  org_domain      = "acme.com"
}

# ── Admin group scoped to the ACME organization ────────────────────────────────

resource "keycloak_group" "acme_admins" {
  realm_id        = data.keycloak_realm.this.id
  name            = "acme-admins"
  organization_id = module.acme.id
}

# ── Globex Corp — minimal configuration ───────────────────────────────────────

module "globex" {
  source = "../../"

  realm_id    = data.keycloak_realm.this.id
  name        = "globex"
  alias       = "globex"
  description = "Globex Corporation tenant."

  domains = {
    "globex.example" = {}
  }
}

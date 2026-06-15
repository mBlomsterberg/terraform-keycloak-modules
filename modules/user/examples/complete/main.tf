################################################################################
# Example: complete — Keycloak user module
#
# Exercises the full surface of the ../../ user module:
#
#   ci_bot          — service-account bot; initial password, roles, attributes
#   alice           — human user; federated Google identity, group membership
#   legacy_admin    — pre-existing user adopted via import_existing = true
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

data "keycloak_role" "deployer" {
  realm_id = data.keycloak_realm.this.id
  name     = "deployer"
}

data "keycloak_role" "viewer" {
  realm_id = data.keycloak_realm.this.id
  name     = "viewer"
}

data "keycloak_group" "engineering" {
  realm_id = data.keycloak_realm.this.id
  name     = "engineering"
}

# ── CI bot — service account with initial password and direct role assignment ──

module "ci_bot" {
  source = "../../"

  realm_id   = data.keycloak_realm.this.id
  username   = "ci-bot"
  email      = "ci-bot@example.com"
  first_name = "CI"
  last_name  = "Bot"

  enabled        = true
  email_verified = true

  initial_password = {
    value     = "change-me-via-tfvars"
    temporary = false
  }

  role_ids         = [data.keycloak_role.deployer.id]
  roles_exhaustive = true

  attributes = {
    managed_by = "terraform"
    team       = "platform"
  }
}

# ── Alice — human user with federated Google identity and group membership ─────

module "alice" {
  source = "../../"

  realm_id   = data.keycloak_realm.this.id
  username   = "alice"
  email      = "alice@example.com"
  first_name = "Alice"
  last_name  = "Example"

  enabled        = true
  email_verified = true

  federated_identities = {
    google = {
      user_id   = "118263748291034857293"
      user_name = "alice@example.com"
    }
  }

  group_ids         = [data.keycloak_group.engineering.id]
  groups_exhaustive = true

  attributes = {
    managed_by = "terraform"
    department = "engineering"
  }
}

# ── Legacy admin — existing user adopted into Terraform state ──────────────────
# import_existing = true tells the provider to look up "legacy-admin" rather
# than creating a new account. Useful for bootstrapping pre-existing users.

module "legacy_admin" {
  source = "../../"

  realm_id        = data.keycloak_realm.this.id
  username        = "legacy-admin"
  import_existing = true

  role_ids = [data.keycloak_role.viewer.id]
}

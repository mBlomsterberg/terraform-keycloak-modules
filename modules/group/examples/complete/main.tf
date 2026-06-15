################################################################################
# Example: complete — Keycloak group module
#
# Exercises the full surface of the ../../ group module:
#
#   engineering     — root group, attributes
#   backend         — child group, role assignment (exhaustive), seeded members
#   frontend        — child group, role assignment
#   ops             — root group, fine-grained admin permissions enabled
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

# ── Realm roles to assign to groups ───────────────────────────────────────────

data "keycloak_role" "developer" {
  realm_id = data.keycloak_realm.this.id
  name     = "developer"
}

data "keycloak_role" "viewer" {
  realm_id = data.keycloak_realm.this.id
  name     = "viewer"
}

# ── Root group — engineering department ───────────────────────────────────────

module "engineering" {
  source = "../../"

  realm_id = data.keycloak_realm.this.id
  name     = "engineering"

  attributes = {
    department  = "engineering"
    managed_by  = "terraform"
    cost_center = "CC-1001"
  }
}

# ── Child group — backend team (roles + members) ───────────────────────────────

module "backend" {
  source = "../../"

  realm_id  = data.keycloak_realm.this.id
  name      = "backend"
  parent_id = module.engineering.id

  role_ids         = [data.keycloak_role.developer.id]
  roles_exhaustive = true

  members = ["alice", "bob"]

  attributes = {
    team       = "backend"
    managed_by = "terraform"
  }
}

# ── Child group — frontend team (roles only) ───────────────────────────────────

module "frontend" {
  source = "../../"

  realm_id  = data.keycloak_realm.this.id
  name      = "frontend"
  parent_id = module.engineering.id

  role_ids = [data.keycloak_role.developer.id]

  attributes = {
    team       = "frontend"
    managed_by = "terraform"
  }
}

# ── Root group — ops, with fine-grained admin permissions ─────────────────────
# Requires the admin_fine_grained_authz preview feature in Keycloak.

module "ops" {
  source = "../../"

  realm_id = data.keycloak_realm.this.id
  name     = "ops"

  role_ids = [data.keycloak_role.viewer.id]

  create_permissions = true
  permissions = {
    view = {
      description       = "Allow admins to view the ops group."
      decision_strategy = "UNANIMOUS"
    }
    manage_members = {
      description       = "Allow admins to manage ops group members."
      decision_strategy = "UNANIMOUS"
    }
  }
}

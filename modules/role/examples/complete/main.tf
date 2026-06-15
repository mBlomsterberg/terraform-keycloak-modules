################################################################################
# Example: complete — standalone Keycloak role module
#
# Exercises the full surface of the ../../ (standalone role) module: a plain
# realm role, a composite realm role aggregating it, and a client-scoped role.
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

data "keycloak_openid_client" "dashboard" {
  realm_id  = data.keycloak_realm.internal.id
  client_id = "dashboard"
}

# ── Plain realm role ───────────────────────────────────────────────────────────
module "viewer" {
  source = "../../"

  realm_id    = data.keycloak_realm.internal.id
  name        = "viewer"
  description = "Read-only access to internal tooling."

  attributes = {
    managed_by = "terraform"
  }
}

# ── Composite realm role — aggregates the viewer role ──────────────────────────
module "admin" {
  source = "../../"

  realm_id        = data.keycloak_realm.internal.id
  name            = "admin"
  description     = "Full access; includes everything granted by viewer."
  composite_roles = [module.viewer.id]
}

# ── Client-scoped role ─────────────────────────────────────────────────────────
module "dashboard_manage" {
  source = "../../"

  realm_id    = data.keycloak_realm.internal.id
  client_id   = data.keycloak_openid_client.dashboard.id
  name        = "manage-dashboard"
  description = "Manage settings within the dashboard client."
}

output "viewer_id" {
  description = "Internal UUID of the viewer realm role."
  value       = module.viewer.id
}

output "admin_id" {
  description = "Internal UUID of the composite admin realm role."
  value       = module.admin.id
}

output "dashboard_manage_id" {
  description = "Internal UUID of the dashboard client role."
  value       = module.dashboard_manage.id
}

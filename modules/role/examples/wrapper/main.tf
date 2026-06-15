################################################################################
# Example: wrapper — manage many roles from one map, composed by map key
#
# Uses the ../../wrappers/roles fan-out module. `composite_roles` entries refer
# to sibling roles by their map key; the wrapper resolves them to role IDs.
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

module "roles" {
  source = "../../wrappers/roles"

  realm_id = data.keycloak_realm.internal.id

  # Shared values applied to every item below unless overridden per entry.
  defaults = {
    attributes = { managed_by = "terraform" }
  }

  items = {
    # Base role — no composites.
    viewer = {
      name        = "viewer"
      description = "Read-only access."
    }

    # Composite role referencing `viewer` by its map key.
    editor = {
      name            = "editor"
      description     = "Read and write access."
      composite_roles = ["viewer"]
    }

    # Transitive composite — includes editor (and therefore viewer).
    admin = {
      name            = "admin"
      description     = "Full access."
      composite_roles = ["editor"]
    }
  }
}

output "role_ids" {
  description = "Logical key => internal Keycloak role UUID."
  value       = module.roles.role_ids
}

output "roles" {
  description = "Full map of managed roles."
  value       = module.roles.roles
}

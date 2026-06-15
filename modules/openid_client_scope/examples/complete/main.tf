################################################################################
# Example: complete — Keycloak OpenID client scope module
#
# Creates three real-world scopes:
#
#   groups          — group membership claim (full_path = false for clean names)
#   profile_extended — custom user attributes + built-in property mappers
#   api_v1          — audience + hardcoded claim for a downstream API
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

# ── groups — group membership claim ───────────────────────────────────────────
# Adds the user's group names (without full path) as a "groups" claim.
# Attach to any client that needs group-based authorisation.

module "groups" {
  source = "../../"

  realm_id               = data.keycloak_realm.this.id
  name                   = "groups"
  description            = "Adds the user's group memberships as a groups claim."
  include_in_token_scope = true

  group_membership_mappers = {
    groups = {
      claim_name          = "groups"
      full_path           = false
      add_to_id_token     = true
      add_to_access_token = true
      add_to_userinfo     = true
    }
  }
}

# ── profile_extended — richer profile claims ───────────────────────────────────
# Extends the standard profile scope with custom attributes and built-in
# properties that Keycloak's default profile scope doesn't expose.

module "profile_extended" {
  source = "../../"

  realm_id               = data.keycloak_realm.this.id
  name                   = "profile_extended"
  description            = "Extended profile: department, cost centre, and full name."
  include_in_token_scope = true

  user_property_mappers = {
    username = {
      user_property = "username"
      claim_name    = "preferred_username"
    }
  }

  user_attribute_mappers = {
    department = {
      user_attribute = "department"
      claim_name     = "department"
    }
    cost_center = {
      user_attribute  = "cost_center"
      claim_name      = "cost_center"
      add_to_userinfo = false
    }
  }

  full_name_mappers = {
    full_name = {
      add_to_id_token     = true
      add_to_access_token = false
      add_to_userinfo     = true
    }
  }
}

# ── api_v1 — downstream API audience and version claim ────────────────────────
# Marks tokens as valid for the api-v1 resource server and stamps the API
# version so the API can gate features without decoding the full JWT.

module "api_v1" {
  source = "../../"

  realm_id               = data.keycloak_realm.this.id
  name                   = "api_v1"
  description            = "Audience and metadata for the v1 API resource server."
  include_in_token_scope = true
  consent_screen_text    = "Access the v1 API on your behalf."

  audience_mappers = {
    api_v1 = {
      included_custom_audience = "api-v1"
      add_to_id_token          = false
      add_to_access_token      = true
    }
  }

  hardcoded_claim_mappers = {
    api_version = {
      claim_name          = "api_version"
      claim_value         = "v1"
      add_to_id_token     = false
      add_to_access_token = true
      add_to_userinfo     = false
    }
  }

  user_realm_role_mappers = {
    realm_roles = {
      claim_name  = "realm_access.roles"
      multivalued = true
    }
  }
}

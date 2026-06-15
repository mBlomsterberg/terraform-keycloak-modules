################################################################################
# Example: complete — Keycloak identity provider module
#
# Exercises the full surface of the ../../ identity_provider module and all
# four sub-modules:
#
#   okta        — generic OIDC provider (root module)
#   google      — Google OIDC (modules/google)
#   microsoft   — Microsoft/Azure AD OIDC (modules/microsoft)
#   github      — GitHub OAuth (modules/github)
#   corporate   — SAML 2.0 provider (modules/saml)
#
# Each call demonstrates at least one mapper type.
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

# ── Generic OIDC provider — Okta ─────────────────────────────────────────────
# Demonstrates attribute-importer, hardcoded-role, and user-template mappers.

module "okta" {
  source = "../../"

  realm_id = data.keycloak_realm.this.id

  alias             = "okta"
  display_name      = "Okta"
  authorization_url = "https://company.okta.com/oauth2/default/v1/authorize"
  token_url         = "https://company.okta.com/oauth2/default/v1/token"
  user_info_url     = "https://company.okta.com/oauth2/default/v1/userinfo"
  jwks_url          = "https://company.okta.com/oauth2/default/v1/keys"
  issuer            = "https://company.okta.com/oauth2/default"
  client_id         = "0oaexampleclientid"
  client_secret     = "super-secret-okta-client-secret"

  default_scopes     = "openid profile email groups"
  validate_signature = true
  trust_email        = true
  sync_mode          = "FORCE"

  attribute_importer_mappers = {
    email = {
      user_attribute = "email"
      claim_name     = "email"
    }
    first_name = {
      user_attribute = "firstName"
      claim_name     = "given_name"
    }
    last_name = {
      user_attribute = "lastName"
      claim_name     = "family_name"
    }
  }

  hardcoded_role_mappers = {
    internal_user = {
      role = "internal-user"
    }
  }

  user_template_importer_mappers = {
    username = {
      template = "$${CLAIM.preferred_username}"
    }
  }
}

# ── Google OIDC provider ──────────────────────────────────────────────────────
# Restricts sign-in to the example.com Workspace domain.
# Demonstrates attribute-importer and hardcoded-group mappers.

module "google" {
  source = "../../modules/google"

  realm_id = data.keycloak_realm.this.id

  alias         = "google"
  display_name  = "Google"
  client_id     = "123456789-example.apps.googleusercontent.com"
  client_secret = "super-secret-google-client-secret"

  hosted_domain         = "example.com"
  request_refresh_token = true
  trust_email           = true

  attribute_importer_mappers = {
    email = {
      user_attribute = "email"
      claim_name     = "email"
    }
    picture = {
      user_attribute = "picture"
      claim_name     = "picture"
    }
  }

  hardcoded_group_mappers = {
    google_users = {
      group = "/google-users"
    }
  }
}

# ── Microsoft / Azure AD OIDC provider ───────────────────────────────────────
# Scoped to a single Azure AD tenant.
# Demonstrates attribute-to-role and hardcoded-attribute mappers.

module "microsoft" {
  source = "../../modules/microsoft"

  realm_id = data.keycloak_realm.this.id

  alias         = "microsoft"
  display_name  = "Microsoft"
  client_id     = "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"
  client_secret = "super-secret-microsoft-client-secret"

  tenant_id   = "ffffffff-0000-1111-2222-333333333333"
  trust_email = true
  sync_mode   = "FORCE"

  attribute_to_role_mappers = {
    engineers = {
      role        = "engineer"
      claim_name  = "groups"
      claim_value = "00000000-aaaa-bbbb-cccc-111111111111"
    }
  }

  hardcoded_attribute_mappers = {
    idp_source = {
      attribute_name  = "idp"
      attribute_value = "microsoft"
      user_session    = false
    }
  }
}

# ── GitHub OAuth provider ─────────────────────────────────────────────────────
# Demonstrates attribute-importer and user-template mappers.

module "github" {
  source = "../../modules/github"

  realm_id = data.keycloak_realm.this.id

  alias         = "github"
  display_name  = "GitHub"
  client_id     = "github_oauth_app_client_id"
  client_secret = "super-secret-github-client-secret"

  trust_email = true

  attribute_importer_mappers = {
    email = {
      user_attribute = "email"
      claim_name     = "email"
    }
  }

  user_template_importer_mappers = {
    username = {
      template = "$${ALIAS}.$${CLAIM.login}"
    }
  }
}

# ── Corporate SAML 2.0 provider ───────────────────────────────────────────────
# Demonstrates attribute-importer and attribute-to-role mappers over SAML.

module "corporate_saml" {
  source = "../../modules/saml"

  realm_id = data.keycloak_realm.this.id

  alias        = "corporate-saml"
  display_name = "Corporate SSO"

  entity_id                  = "https://auth.example.com/realms/internal"
  single_sign_on_service_url = "https://sso.corporate.example/saml2/idp/SSO"
  single_logout_service_url  = "https://sso.corporate.example/saml2/idp/SLO"

  post_binding_response      = true
  post_binding_authn_request = true
  want_assertions_signed     = true
  validate_signature         = true
  signing_certificate        = "MIIDpDCCAoygAwIBAgIGAX..."

  name_id_policy_format = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"
  principal_type        = "ATTRIBUTE"
  principal_attribute   = "email"
  trust_email           = true

  attribute_importer_mappers = {
    email = {
      user_attribute          = "email"
      attribute_friendly_name = "email"
    }
    first_name = {
      user_attribute          = "firstName"
      attribute_friendly_name = "givenName"
    }
    last_name = {
      user_attribute          = "lastName"
      attribute_friendly_name = "sn"
    }
  }

  attribute_to_role_mappers = {
    admins = {
      role            = "realm-admin"
      attribute_name  = "memberOf"
      attribute_value = "CN=KeycloakAdmins,OU=Groups,DC=corporate,DC=example"
    }
  }
}

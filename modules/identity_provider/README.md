# Keycloak Identity Provider Terraform module

Terraform module which creates Keycloak identity provider resources.

The root module manages a generic OIDC identity provider (`keycloak_oidc_identity_provider`) and all seven mapper types. Dedicated sub-modules are provided for Google, GitHub, Microsoft, and SAML providers.

## Usage

See the [`examples/`](./examples) directory for working configurations. A minimal call creating an OIDC provider with an attribute-importer mapper:

```hcl
module "okta" {
  source = "path/to/modules/identity_provider"

  realm_id = data.keycloak_realm.this.id

  alias             = "okta"
  display_name      = "Okta"
  authorization_url = "https://company.okta.com/oauth2/default/v1/authorize"
  token_url         = "https://company.okta.com/oauth2/default/v1/token"
  client_id         = "0oaexampleclientid"
  client_secret     = var.okta_client_secret

  attribute_importer_mappers = {
    email = {
      user_attribute = "email"
      claim_name     = "email"
    }
  }
}
```

## Sub-modules

Each sub-module wraps a provider-specific Keycloak resource and shares the same mapper interface as the root module.

| Sub-module | Resource |
|---|---|
| [`modules/google`](./modules/google) | `keycloak_oidc_google_identity_provider` |
| [`modules/github`](./modules/github) | `keycloak_oidc_github_identity_provider` |
| [`modules/microsoft`](./modules/microsoft) | `keycloak_oidc_microsoft_identity_provider` |
| [`modules/saml`](./modules/saml) | `keycloak_saml_identity_provider` |

```hcl
module "google" {
  source = "path/to/modules/identity_provider/modules/google"

  realm_id      = data.keycloak_realm.this.id
  client_id     = var.google_client_id
  client_secret = var.google_client_secret
  hosted_domain = "example.com"
}

module "corporate_saml" {
  source = "path/to/modules/identity_provider/modules/saml"

  realm_id                   = data.keycloak_realm.this.id
  alias                      = "corporate-saml"
  entity_id                  = "https://keycloak.example.com/realms/internal"
  single_sign_on_service_url = "https://sso.corporate.example/saml2/idp/SSO"
  signing_certificate        = file("corporate-idp.pem")
  validate_signature         = true
}
```

## Mappers

All five modules (root + four sub-modules) expose the same seven mapper variables. Map keys become the mapper `name` in Keycloak. The `local.idp_alias` in each module creates an implicit dependency so mappers are always created after the provider.

| Variable | Resource |
|---|---|
| `attribute_importer_mappers` | `keycloak_attribute_importer_identity_provider_mapper` |
| `attribute_to_role_mappers` | `keycloak_attribute_to_role_identity_provider_mapper` |
| `hardcoded_role_mappers` | `keycloak_hardcoded_role_identity_provider_mapper` |
| `hardcoded_attribute_mappers` | `keycloak_hardcoded_attribute_identity_provider_mapper` |
| `hardcoded_group_mappers` | `keycloak_hardcoded_group_identity_provider_mapper` |
| `user_template_importer_mappers` | `keycloak_user_template_importer_identity_provider_mapper` |
| `custom_mappers` | `keycloak_custom_identity_provider_mapper` |

```hcl
attribute_importer_mappers = {
  email = {
    user_attribute = "email"
    claim_name     = "email"
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
```

## Client secret

Use either `client_secret` (stored in state) or the write-only pair `client_secret_wo` + `client_secret_wo_version` (requires Terraform >= 1.11, not stored in state). Increment `client_secret_wo_version` to rotate the secret without exposing its value.

```hcl
client_secret_wo         = var.okta_client_secret
client_secret_wo_version = "v2"
```

## Wrapper

To create multiple generic OIDC providers in a single call, use the `wrappers/identity_providers` sub-module:

```hcl
module "identity_providers" {
  source = "path/to/modules/identity_provider/wrappers/identity_providers"

  realm_id = data.keycloak_realm.this.id

  defaults = {
    trust_email = true
    sync_mode   = "FORCE"
  }

  items = {
    okta = {
      alias             = "okta"
      authorization_url = "https://company.okta.com/oauth2/default/v1/authorize"
      token_url         = "https://company.okta.com/oauth2/default/v1/token"
      client_id         = "0oaexampleclientid"
      client_secret     = var.okta_client_secret
    }
    auth0 = {
      alias             = "auth0"
      authorization_url = "https://company.auth0.com/authorize"
      token_url         = "https://company.auth0.com/oauth/token"
      client_id         = "auth0clientid"
      client_secret     = var.auth0_client_secret
    }
  }
}
```

## Examples

- [complete](./examples/complete) — generic OIDC (Okta), Google, Microsoft, GitHub, and SAML providers, each with representative mappers.

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

## License

Apache-2.0 Licensed. See [LICENSE](../../LICENSE).

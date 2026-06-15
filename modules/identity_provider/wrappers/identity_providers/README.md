# Keycloak identity providers wrapper

Thin fan-out wrapper over the `../../` identity provider module. Creates multiple generic OIDC identity providers in a single call.

## Usage

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
      attribute_importer_mappers = {
        email = { user_attribute = "email", claim_name = "email" }
      }
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

# Access individual providers via the wrapper output:
output "okta_alias" {
  value = module.identity_providers.wrapper["okta"].alias
}
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

## License

Apache-2.0 Licensed. See [LICENSE](../../../LICENSE).

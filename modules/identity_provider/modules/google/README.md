# Keycloak Google Identity Provider sub-module

Terraform sub-module which creates a `keycloak_oidc_google_identity_provider` resource and all seven mapper types.

## Usage

```hcl
module "google" {
  source = "path/to/modules/identity_provider/modules/google"

  realm_id      = data.keycloak_realm.this.id
  client_id     = "123456789-example.apps.googleusercontent.com"
  client_secret = var.google_client_secret

  hosted_domain         = "example.com"
  request_refresh_token = true
  trust_email           = true

  attribute_importer_mappers = {
    email = {
      user_attribute = "email"
      claim_name     = "email"
    }
  }
}
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

## License

Apache-2.0 Licensed. See [LICENSE](../../../../LICENSE).

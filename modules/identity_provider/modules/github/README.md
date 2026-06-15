# Keycloak GitHub Identity Provider sub-module

Terraform sub-module which creates a `keycloak_oidc_github_identity_provider` resource and all seven mapper types.

## Usage

```hcl
module "github" {
  source = "path/to/modules/identity_provider/modules/github"

  realm_id      = data.keycloak_realm.this.id
  client_id     = "github_oauth_app_client_id"
  client_secret = var.github_client_secret

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
```

For GitHub Enterprise Server, override `base_url` and `api_url`:

```hcl
base_url = "https://github.corporate.example"
api_url  = "https://github.corporate.example/api/v3"
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

## License

Apache-2.0 Licensed. See [LICENSE](../../../../LICENSE).

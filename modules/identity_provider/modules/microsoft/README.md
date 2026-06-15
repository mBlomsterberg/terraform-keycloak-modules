# Keycloak Microsoft Identity Provider sub-module

Terraform sub-module which creates a `keycloak_oidc_microsoft_identity_provider` resource and all seven mapper types.

## Usage

```hcl
module "microsoft" {
  source = "path/to/modules/identity_provider/modules/microsoft"

  realm_id      = data.keycloak_realm.this.id
  client_id     = "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"
  client_secret = var.microsoft_client_secret

  tenant_id   = "ffffffff-0000-1111-2222-333333333333"
  trust_email = true

  attribute_to_role_mappers = {
    engineers = {
      role        = "engineer"
      claim_name  = "groups"
      claim_value = "00000000-aaaa-bbbb-cccc-111111111111"
    }
  }
}
```

Leave `tenant_id` as null to use the multi-tenant (common) endpoint, which allows sign-in from any Azure AD tenant.

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

## License

Apache-2.0 Licensed. See [LICENSE](../../../../LICENSE).

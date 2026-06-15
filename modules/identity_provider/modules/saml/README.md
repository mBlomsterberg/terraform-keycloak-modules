# Keycloak SAML Identity Provider sub-module

Terraform sub-module which creates a `keycloak_saml_identity_provider` resource and all seven mapper types.

## Usage

```hcl
module "corporate_saml" {
  source = "path/to/modules/identity_provider/modules/saml"

  realm_id = data.keycloak_realm.this.id

  alias        = "corporate-saml"
  display_name = "Corporate SSO"

  entity_id                  = "https://keycloak.example.com/realms/internal"
  single_sign_on_service_url = "https://sso.corporate.example/saml2/idp/SSO"
  single_logout_service_url  = "https://sso.corporate.example/saml2/idp/SLO"

  post_binding_response      = true
  post_binding_authn_request = true
  want_assertions_signed     = true
  validate_signature         = true
  signing_certificate        = file("corporate-idp.pem")

  name_id_policy_format = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"

  attribute_importer_mappers = {
    email = {
      user_attribute          = "email"
      attribute_friendly_name = "email"
    }
    first_name = {
      user_attribute          = "firstName"
      attribute_friendly_name = "givenName"
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
```

## Signature validation

When `validate_signature = true`, provide the IdP's signing certificate as a PEM-encoded string without the `-----BEGIN CERTIFICATE-----` / `-----END CERTIFICATE-----` header and footer.

```hcl
validate_signature  = true
signing_certificate = trimspace(replace(file("idp-signing.pem"), "/-----[A-Z ]+-----/", ""))
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

## License

Apache-2.0 Licensed. See [LICENSE](../../../../LICENSE).

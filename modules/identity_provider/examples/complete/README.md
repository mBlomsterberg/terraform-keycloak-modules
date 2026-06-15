# Complete example — Keycloak Identity Provider module

Configuration in this directory creates:

- An **Okta** generic OIDC identity provider (root module) with attribute-importer, hardcoded-role, and user-template mappers
- A **Google** OIDC provider (`modules/google`) restricted to a Workspace domain, with attribute-importer and hardcoded-group mappers
- A **Microsoft/Azure AD** OIDC provider (`modules/microsoft`) scoped to a single tenant, with attribute-to-role and hardcoded-attribute mappers
- A **GitHub** OAuth provider (`modules/github`) with attribute-importer and user-template mappers
- A **corporate SAML 2.0** provider (`modules/saml`) with attribute-importer and attribute-to-role mappers

These examples serve two purposes: working reference configurations and a way to validate module changes. They are not intended as opinionated best practices.

## Usage

```bash
terraform init
terraform plan
terraform apply
```

> **Cost:** Keycloak is self-hosted — there is no cloud cost for these resources. Run `terraform destroy` to remove all created identity providers when you are done.

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

Apache-2.0 Licensed. See [LICENSE](../../../../LICENSE).

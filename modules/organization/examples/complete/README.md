# Complete example — Keycloak Organization module

Configuration in this directory creates:

- An **ACME** enterprise organization with two email domains (one verified), custom attributes, a redirect URL, a scoped Google identity provider, and a scoped admin group
- A **Globex** minimal organization with one unverified domain

These examples serve two purposes: working reference configurations and a way to validate module changes. They are not intended as opinionated best practices.

## Usage

```bash
terraform init
terraform plan
terraform apply
```

> **Cost:** Keycloak is self-hosted — there is no cloud cost for these resources. Run `terraform destroy` to remove all created organizations when you are done.

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

Apache-2.0 Licensed. See [LICENSE](../../../../LICENSE).

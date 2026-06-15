# Complete example — Keycloak Group module

Configuration in this directory creates:

- An **engineering** root group with custom attributes
- A **backend** child group under engineering, with a role assignment and seeded members
- A **frontend** child group under engineering, with a role assignment
- An **ops** root group with fine-grained admin permissions enabled (requires `admin_fine_grained_authz` preview feature)

These examples serve two purposes: working reference configurations and a way to validate module changes. They are not intended as opinionated best practices.

## Usage

```bash
terraform init
terraform plan
terraform apply
```

> **Cost:** Keycloak is self-hosted — there is no cloud cost for these resources. Run `terraform destroy` to remove all created groups when you are done.

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

Apache-2.0 Licensed. See [LICENSE](../../../../LICENSE).

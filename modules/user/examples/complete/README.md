# Complete example — Keycloak User module

Configuration in this directory creates:

- A **CI bot** service account with an initial password, direct role assignment, and custom attributes
- **Alice**, a human user account linked to a Google federated identity with group membership
- A **legacy admin**, an existing user adopted into Terraform state using `import_existing = true`

These examples serve two purposes: working reference configurations and a way to validate module changes. They are not intended as opinionated best practices.

## Usage

```bash
terraform init
terraform plan
terraform apply
```

> **Cost:** Keycloak is self-hosted — there is no cloud cost for these resources. Run `terraform destroy` to remove all created users when you are done. Note that the `legacy_admin` user was imported, not created, so destroying it will remove it from Keycloak.

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

Apache-2.0 Licensed. See [LICENSE](../../../../LICENSE).

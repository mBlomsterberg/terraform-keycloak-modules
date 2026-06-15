# Complete example — Keycloak OpenID Client Scope module

Configuration in this directory creates:

- A **groups** scope with a group-membership mapper (group names without full path)
- A **profile_extended** scope with a user-property mapper, two user-attribute mappers, and a full-name mapper
- An **api_v1** scope with an audience mapper, a hardcoded-claim mapper, and a realm-role mapper

These examples serve two purposes: working reference configurations and a way to validate module changes. They are not intended as opinionated best practices.

## Usage

```bash
terraform init
terraform plan
terraform apply
```

> **Cost:** Keycloak is self-hosted — there is no cloud cost for these resources. Run `terraform destroy` to remove all created scopes when you are done.

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

Apache-2.0 Licensed. See [LICENSE](../../../../LICENSE).

# Keycloak User — users wrapper

Creates multiple `user` module instances from a single map, following the [terraform-aws-modules wrapper convention](https://github.com/terraform-aws-modules).

## Usage

```hcl
module "service_accounts" {
  source = "path/to/modules/user/wrappers/users"

  realm_id = data.keycloak_realm.this.id

  defaults = {
    email_verified = true
    attributes     = { managed_by = "terraform" }
  }

  items = {
    ci_bot = {
      username = "ci-bot"
      email    = "ci-bot@example.com"
      role_ids = [module.deployer_role.id]
    }
    audit_reader = {
      username = "audit-reader"
      email    = "audit-reader@example.com"
      role_ids = [module.reader_role.id]
    }
  }
}
```

## Outputs

| Name | Description |
|------|-------------|
| `wrapper` | Map of all managed `user` module instances keyed by `var.items` key. Marked sensitive because module instances can expose password-related state. Access individual attributes via `module.service_accounts.wrapper["ci_bot"].id`. |

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

Apache-2.0 Licensed. See [LICENSE](../../../../LICENSE).

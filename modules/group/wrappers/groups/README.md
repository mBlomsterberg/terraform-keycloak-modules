# Keycloak Group — groups wrapper

Creates multiple `group` module instances from a single map, following the [terraform-aws-modules wrapper convention](https://github.com/terraform-aws-modules).

## Usage

```hcl
module "groups" {
  source = "path/to/modules/group/wrappers/groups"

  realm_id = data.keycloak_realm.this.id

  defaults = {
    attributes = { managed_by = "terraform" }
  }

  items = {
    engineering = {
      name = "engineering"
    }
    backend = {
      name      = "backend"
      parent_id = module.groups.wrapper["engineering"].id
      role_ids  = [module.developer_role.id]
      members   = ["alice", "bob"]
    }
  }
}
```

## Outputs

| Name | Description |
|------|-------------|
| `wrapper` | Map of all managed `group` module instances keyed by `var.items` key. Access individual attributes via `module.groups.wrapper["engineering"].id`. |

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

Apache-2.0 Licensed. See [LICENSE](../../../../LICENSE).

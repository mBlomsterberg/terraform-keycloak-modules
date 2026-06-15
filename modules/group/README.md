# Keycloak Group Terraform module

Terraform module which creates Keycloak group resources.

## Usage

See the [`examples/`](./examples) directory for working configurations. A minimal call creating a child group with roles and members:

```hcl
module "backend" {
  source = "path/to/modules/group"

  realm_id  = data.keycloak_realm.this.id
  name      = "backend"
  parent_id = module.engineering.id

  attributes = {
    team       = "backend"
    managed_by = "terraform"
  }

  role_ids = [module.developer_role.id]
  members  = ["alice", "bob"]
}
```

## Group hierarchy

Groups can be nested to any depth by passing `parent_id`. The most natural pattern is to call this module once per group and wire the hierarchy through outputs:

```hcl
module "engineering" {
  source   = "path/to/modules/group"
  realm_id = data.keycloak_realm.this.id
  name     = "engineering"
}

module "backend" {
  source    = "path/to/modules/group"
  realm_id  = data.keycloak_realm.this.id
  name      = "backend"
  parent_id = module.engineering.id   # resolves to the UUID at plan time
}
```

The computed `path` output reflects the full hierarchy (e.g. `/engineering/backend`) and is useful for debugging or for passing to identity provider mappers.

## Role assignments

Set `role_ids` to a list of already-resolved role UUIDs (realm or client roles). By default `roles_exhaustive = true`, meaning Terraform is the authoritative source for the group's roles — any roles added manually will be removed on the next apply. Set `roles_exhaustive = false` to allow multiple partial role-assignment resources for the same group (e.g. one managed by this module, one by another).

```hcl
role_ids         = [module.developer.id, data.keycloak_role.viewer.id]
roles_exhaustive = true
```

## Membership

Set `members` to a list of usernames to seed the group with known accounts. A `keycloak_group_memberships` resource is created only when the list is non-empty.

> **Note:** Do not combine `members` with `keycloak_default_groups` for the same group — the provider will conflict. Use `keycloak_default_groups` (outside this module, at the realm level) only for groups whose members are _not_ managed by Terraform.

## Fine-grained permissions

Set `create_permissions = true` to enable the `keycloak_group_permissions` resource, which lets you attach authorization policies to each admin scope (`view`, `manage`, `view_members`, `manage_members`, `manage_membership`). This requires the `admin_fine_grained_authz` preview feature to be enabled in Keycloak.

```hcl
create_permissions = true
permissions = {
  manage_members = {
    policies          = [keycloak_openid_client_group_policy.ops_admins.id]
    decision_strategy = "UNANIMOUS"
  }
}
```

Omitting a scope block leaves that scope unconfigured (no policy restriction).

## Wrapper

To create many groups in a single call, use the `wrappers/groups` sub-module:

```hcl
module "groups" {
  source = "path/to/modules/group/wrappers/groups"

  realm_id = data.keycloak_realm.this.id

  defaults = {
    attributes = { managed_by = "terraform" }
  }

  items = {
    engineering = { name = "engineering" }
    backend     = { name = "backend", parent_id = module.groups.wrapper["engineering"].id }
    frontend    = { name = "frontend", parent_id = module.groups.wrapper["engineering"].id }
  }
}
```

> **Note:** Parent-child relationships within the same `items` map require two `terraform apply` passes (the parent must exist before its ID is known), or split parent and child groups across separate wrapper calls.

## Examples

- [complete](./examples/complete) — root group with attributes, child groups with role assignments and members, and a group with fine-grained admin permissions.

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

## License

Apache-2.0 Licensed. See [LICENSE](../../LICENSE).

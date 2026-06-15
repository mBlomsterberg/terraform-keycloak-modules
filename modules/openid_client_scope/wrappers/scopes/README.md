# Keycloak OpenID Client Scope — scopes wrapper

Creates multiple `openid_client_scope` module instances from a single map, following the [terraform-aws-modules wrapper convention](https://github.com/terraform-aws-modules).

## Usage

```hcl
module "scopes" {
  source = "path/to/modules/openid_client_scope/wrappers/scopes"

  realm_id = data.keycloak_realm.this.id

  items = {
    groups = {
      name        = "groups"
      description = "Adds group memberships to the token."
      group_membership_mappers = {
        groups = { claim_name = "groups", full_path = false }
      }
    }
    roles = {
      name        = "roles"
      description = "Adds realm and client roles to the token."
      user_realm_role_mappers = {
        realm_roles = { claim_name = "realm_access.roles", multivalued = true }
      }
    }
  }
}

# module.scopes.wrapper["groups"].name  => "groups"
# module.scopes.wrapper["groups"].id    => "<uuid>"
```

## Outputs

| Name | Description |
|------|-------------|
| `wrapper` | Map of all managed `openid_client_scope` module instances keyed by `var.items` key. |

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

Apache-2.0 Licensed. See [LICENSE](../../../../LICENSE).

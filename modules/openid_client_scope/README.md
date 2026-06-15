# Keycloak OpenID Client Scope Terraform module

Terraform module which creates Keycloak OpenID Connect client scope resources.

A client scope is a named, reusable set of protocol mappers (and optionally consent text) that can be attached to many clients. Scopes are the right place to define what goes into a token — the client module then references them by name.

## Usage

See the [`examples/`](./examples) directory for working configurations. A representative call creating a `groups` scope:

```hcl
module "groups_scope" {
  source = "path/to/modules/openid_client_scope"

  realm_id    = data.keycloak_realm.this.id
  name        = "groups"
  description = "Adds the user's group memberships as a groups claim."

  group_membership_mappers = {
    groups = {
      claim_name = "groups"
      full_path  = false
    }
  }
}
```

## Assigning scopes to clients

Clients reference scopes by **name**, not by ID. Pass `module.groups_scope.name` wherever a scope name is expected. The `client` module (once extended with scope-assignment variables) accepts them as lists:

```hcl
module "dashboard" {
  source   = "path/to/modules/client"
  realm_id = data.keycloak_realm.this.id
  client_id = "dashboard"

  # scopes must exist before they can be assigned
  default_scopes  = ["openid", "profile", "email", module.groups_scope.name]
  optional_scopes = ["offline_access", module.api_scope.name]
}
```

Alternatively, manage scope assignment directly with `keycloak_openid_client_default_scopes` and `keycloak_openid_client_optional_scopes` outside the module when you need fine-grained control.

## Protocol mappers

Every mapper type is a **map of objects** keyed by a stable logical name that becomes the mapper's display name in the Keycloak admin console. All mapper resources use `local.scope_id` (the computed UUID of the scope) as `client_scope_id`, so Terraform automatically orders creation correctly.

### Available mapper types

| Variable | Resource | Purpose |
|---|---|---|
| `user_attribute_mappers` | `keycloak_openid_user_attribute_protocol_mapper` | Custom user attributes → claim |
| `user_property_mappers` | `keycloak_openid_user_property_protocol_mapper` | Built-in properties (email, username) → claim |
| `group_membership_mappers` | `keycloak_openid_group_membership_protocol_mapper` | Group memberships → claim |
| `user_realm_role_mappers` | `keycloak_openid_user_realm_role_protocol_mapper` | Realm roles → claim |
| `user_client_role_mappers` | `keycloak_openid_user_client_role_protocol_mapper` | Client-specific roles → claim |
| `audience_mappers` | `keycloak_openid_audience_protocol_mapper` | Add entry to token `aud` claim |
| `hardcoded_claim_mappers` | `keycloak_openid_hardcoded_claim_protocol_mapper` | Fixed claim value on every token |
| `full_name_mappers` | `keycloak_openid_full_name_protocol_mapper` | `firstName + lastName` → `name` claim |

### Token inclusion flags

Every mapper type exposes `add_to_id_token`, `add_to_access_token`, and `add_to_userinfo` (all default `true`). Set them to `false` to suppress the claim in specific token types without removing the mapper entirely.

## Wrapper

To create many scopes from a single map, use the `wrappers/scopes` sub-module:

```hcl
module "scopes" {
  source = "path/to/modules/openid_client_scope/wrappers/scopes"

  realm_id = data.keycloak_realm.this.id

  items = {
    groups = {
      name = "groups"
      group_membership_mappers = {
        groups = { claim_name = "groups", full_path = false }
      }
    }
    roles = {
      name = "roles"
      user_realm_role_mappers = {
        realm_roles = { claim_name = "realm_roles", multivalued = true }
      }
    }
  }
}

# module.scopes.wrapper["groups"].name => "groups"
```

## Examples

- [complete](./examples/complete) — three real-world scopes: `groups` (group membership), `profile_extended` (user attributes + property), and `api_v1` (audience + hardcoded claim).

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

## License

Apache-2.0 Licensed. See [LICENSE](../../LICENSE).

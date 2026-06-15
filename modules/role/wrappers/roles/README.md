# Keycloak Roles module (wrapper)

Manages **many** `keycloak_role` resources in a single realm from a map. It is a
thin fan-out over the standalone [`../../`](../../) role module, following the
[terraform-aws-modules wrapper](https://github.com/terraform-aws-modules/terraform-aws-lambda/tree/master/wrappers)
convention.

Each argument resolves via `try(each.value.X, var.defaults.X, null)`, so values
fall through three layers, most specific first:

1. a value set on the individual item in `var.items`, else
2. the shared `var.defaults` value, else
3. `null` is forwarded and the standalone module's own default applies.

## Composite roles by map key

`composite_roles` is the cross-reference mechanism between roles. Each entry is
resolved against the map: if it matches **another item's key**, it is replaced
with that sibling's role ID; otherwise it is passed through as a literal role ID
(e.g. a role created elsewhere). So you compose roles by referring to the keys
you defined, without threading IDs around yourself.

## Usage

```hcl
data "keycloak_realm" "internal" {
  realm = "internal"
}

module "roles" {
  source = "../../wrappers/roles"

  realm_id = data.keycloak_realm.internal.id

  defaults = {
    attributes = { managed_by = "terraform" }
  }

  items = {
    viewer = {
      name        = "viewer"
      description = "Read-only access."
    }

    editor = {
      name            = "editor"
      description     = "Read and write access."
      composite_roles = ["viewer"] # references the `viewer` item by key
    }

    admin = {
      name            = "admin"
      description     = "Full access."
      composite_roles = ["editor"] # transitively includes viewer
    }
  }
}
```

## Inputs

- `realm_id` (required) — internal realm ID, e.g. `data.keycloak_realm.this.id`.
- `items` — map of role objects keyed by a stable logical name. `name` is
  required per entry; every other field is optional. Untyped (`any`); the
  accepted fields are those of the standalone [`../../`](../../) module. In
  `composite_roles`, an entry matching another item's key is resolved to that
  sibling's role ID.
- `defaults` — map of field values applied to every item unless overridden on
  the entry. `name` should not be set here (it must be unique).

## Outputs

- `roles` — full map of `{ id, name, client_id }`.
- `role_ids` — logical key => internal role UUID.

# Keycloak Role module (standalone)

Manages a **single** `keycloak_role` — either a realm role (`client_id = null`)
or a client role (`client_id` set). Realm membership is injected via `realm_id`,
so the module is decoupled from realm state and reusable across every realm. To
manage many roles (and their composite relationships) from one map, use the
[`../roles`](./wrappers/roles) wrapper instead.

## Usage

```hcl
data "keycloak_realm" "internal" {
  realm = "internal"
}

# A plain realm role.
module "viewer" {
  source = "../role"

  realm_id    = data.keycloak_realm.internal.id
  name        = "viewer"
  description = "Read-only access."
}

# A composite role that aggregates other roles by their resolved IDs.
module "admin" {
  source = "../role"

  realm_id        = data.keycloak_realm.internal.id
  name            = "admin"
  description     = "Full access."
  composite_roles = [module.viewer.id]
}
```

## Realm vs. client roles

A role is a **realm role** when `client_id` is null (the default) and a **client
role** when `client_id` is set to a client's internal ID. Wire a client role to
its client by passing the client module's `id` output:

```hcl
module "billing_manage" {
  source = "../role"

  realm_id  = data.keycloak_realm.internal.id
  client_id = module.billing_client.id # scopes the role to that client
  name      = "manage-invoices"
}
```

## Composite roles

A composite role aggregates other roles: granting it implicitly grants every
role it contains. `composite_roles` takes already-resolved role **IDs**. When
managing many roles together, the [`../roles`](./wrappers/roles) wrapper lets you
reference sibling roles by their **map key** and resolves the IDs for you.

## Outputs

- `id` — internal role UUID; use it in `composite_roles` and role mappings.
- `name` — the role name.
- `client_id` — the client this role is scoped to, or null for a realm role.

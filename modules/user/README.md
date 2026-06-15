# Keycloak User Terraform module

Terraform module which creates Keycloak user resources.

Intended for service accounts, bot users, and seeded test accounts — not for managing the full population of human users (which should self-register). Each user can have an initial password, federated identity links, group memberships, and direct role assignments.

## Usage

See the [`examples/`](./examples) directory for working configurations. A representative call:

```hcl
module "ci_bot" {
  source = "path/to/modules/user"

  realm_id  = data.keycloak_realm.this.id
  username  = "ci-bot"
  email     = "ci-bot@example.com"
  first_name = "CI"
  last_name  = "Bot"

  email_verified = true

  initial_password = {
    value     = var.ci_bot_password
    temporary = false
  }

  role_ids = [module.deployer_role.id]

  attributes = {
    managed_by = "terraform"
    team       = "platform"
  }
}
```

## Initial password

`initial_password` sets the password at creation time only. Subsequent changes to `value` are **not** applied — Keycloak does not expose password hashes through the API. To force a user to reset their password, add `"UPDATE_PASSWORD"` to `required_actions`:

```hcl
required_actions = ["UPDATE_PASSWORD"]
```

Set `temporary = true` (the default) to force the user to change the password on first login.

## Federated identities

Link this Keycloak user to an external account using `federated_identities`, keyed by the identity provider alias:

```hcl
federated_identities = {
  google = {
    user_id   = "118263...google-sub..."
    user_name = "alice@example.com"
  }
}
```

## Group membership

Set `group_ids` to a list of group UUIDs. By default `groups_exhaustive = true`, making Terraform the authoritative source for this user's group membership. Set to `false` to manage only a subset of memberships.

## Role assignments

Set `role_ids` to a list of realm or client role UUIDs. `roles_exhaustive = true` (the default) removes any manually added roles on the next apply.

## Importing pre-existing users

Set `import_existing = true` to adopt a user that already exists in Keycloak instead of creating a new one. Keycloak will look up the user by `username` and import its state. This is distinct from the Terraform `import` block — it is a provider-level flag that prevents the provider from calling the create API.

## Wrapper

To create many users from a single map, use the `wrappers/users` sub-module:

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

## Examples

- [complete](./examples/complete) — service-account bot with roles, a federated user with group membership, and an imported pre-existing user.

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

## License

Apache-2.0 Licensed. See [LICENSE](../../LICENSE).

# Keycloak Organization Terraform module

Terraform module which creates Keycloak organization resources.

Organizations are a Keycloak 26+ multi-tenant feature. Each organization groups a set of users under a namespace with its own email domains, identity providers, and groups.

## Usage

See the [`examples/`](./examples) directory for working configurations. A representative call:

```hcl
module "acme" {
  source = "path/to/modules/organization"

  realm_id     = data.keycloak_realm.this.id
  name         = "acme"
  alias        = "acme"
  description  = "ACME Corporation tenant."
  redirect_url = "https://app.example.com/welcome"

  domains = {
    "acme.com"    = { verified = true }
    "acme.org"    = { verified = false }
  }

  attributes = {
    tier       = "enterprise"
    managed_by = "terraform"
  }
}
```

## Domains

The `domains` variable is a **map of objects** keyed by domain name. Keycloak associates users whose email matches a listed domain with the organization automatically. Set `verified = true` once you have confirmed ownership of the domain through Keycloak's domain-verification flow.

```hcl
domains = {
  "example.com" = { verified = true }
  "example.io"  = { verified = false }
}
```

> **Note:** The `alias` field cannot be changed after the organization is created. Changing it forces Terraform to destroy and re-create the resource, which will remove all organization members and break any identity providers referencing the old alias.

## Wiring to other resources

Pass `module.acme.id` as `organization_id` wherever the provider accepts it — identity providers and groups can both be scoped to an organization:

```hcl
module "google_idp" {
  source = "path/to/modules/identity_provider/modules/google"

  realm_id        = data.keycloak_realm.this.id
  alias           = "acme-google"
  client_id       = "..."
  client_secret   = "..."
  organization_id = module.acme.id
}

module "acme_admins" {
  source = "path/to/modules/group"

  realm_id        = data.keycloak_realm.this.id
  name            = "acme-admins"
  organization_id = module.acme.id
}
```

## Wrapper

To create many organizations from one map, use the `wrappers/organizations` sub-module:

```hcl
module "orgs" {
  source = "path/to/modules/organization/wrappers/organizations"

  realm_id = data.keycloak_realm.this.id

  defaults = {
    enabled    = true
    attributes = { managed_by = "terraform" }
  }

  items = {
    acme = {
      name    = "acme"
      alias   = "acme"
      domains = { "acme.com" = { verified = true } }
    }
    globex = {
      name    = "globex"
      alias   = "globex"
      domains = { "globex.example" = {} }
    }
  }
}

# Access: module.orgs.wrapper["acme"].id
```

## Examples

- [complete](./examples/complete) — two organizations with domains, attributes, redirect URLs, and downstream wiring to an identity provider and a group.

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

## License

Apache-2.0 Licensed. See [LICENSE](../../LICENSE).

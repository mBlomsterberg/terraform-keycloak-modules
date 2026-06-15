# Keycloak OpenID Clients module (wrapper)

Manages **many** `keycloak_openid_client` resources in a single realm from a map.
It is a thin fan-out over the standalone [`../../`](../../) client module,
following the [terraform-aws-modules wrapper](https://github.com/terraform-aws-modules/terraform-aws-lambda/tree/master/wrappers)
convention.

Each argument resolves via `try(each.value.X, var.defaults.X, null)`, so values
fall through three layers, most specific first:

1. a value set on the individual item in `var.items`, else
2. the shared `var.defaults` value, else
3. `null` is forwarded and the standalone module's own (secure) default applies.

So shared settings can be declared once in `defaults`, and the standalone
module's secure defaults still apply to anything left unset everywhere.

## Usage

```hcl
data "keycloak_realm" "internal" {
  realm = "internal"
}

module "clients" {
  source = "../../wrappers/clients"

  realm_id = data.keycloak_realm.internal.id

  # Applied to every item unless overridden per entry.
  defaults = {
    web_origins = ["https://example.com"]
    login_theme = "example"
  }

  items = {
    dashboard = {
      client_id           = "dashboard"
      name                = "Dashboard"
      valid_redirect_uris = ["https://app.example.com/*"]
      # inherits web_origins and login_theme from defaults
    }

    dashboard_tv = {
      client_id                                 = "dashboard-tv"
      name                                      = "TV Dashboard"
      standard_flow_enabled                     = false
      oauth2_device_authorization_grant_enabled = true
      login_theme                               = "example-tv" # overrides the default
    }
  }
}
```

## Inputs

- `realm_id` (required) — internal realm ID, e.g. `data.keycloak_realm.this.id`.
- `items` — map of client objects keyed by a stable logical name. `client_id` is
  required per entry; every other field is optional. Untyped (`any`); the
  accepted fields are those of the standalone [`../../`](../../) module.
- `defaults` — map of field values applied to every item unless overridden on
  the entry. `client_id` should not be set here (it must be unique).

## Outputs

- `clients` — full map of `{ id, client_id, service_account_user_id, resource_server_id }`.
- `client_ids` — logical key => internal client UUID.
- `service_account_user_ids` — logical key => service-account user ID.

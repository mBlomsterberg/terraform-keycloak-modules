# Keycloak Realms module (wrapper)

Manages **many** `keycloak_realm` resources from a map. It is a thin fan-out over
the standalone [`../../`](../../) realm module, following the
[terraform-aws-modules wrapper](https://github.com/terraform-aws-modules/terraform-aws-lambda/tree/master/wrappers)
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
module "realms" {
  source = "../../wrappers/realms"

  # Applied to every item unless overridden per entry.
  defaults = {
    ssl_required    = "all"
    login_theme     = "example"
    verify_email    = true
    password_policy = "upperCase(1) and length(12) and notUsername"
  }

  items = {
    internal = {
      realm        = "internal"
      display_name = "Example Internal"
      # inherits ssl_required, login_theme, verify_email, password_policy
    }

    customers = {
      realm                = "customers"
      display_name         = "Example Customers"
      registration_allowed = true # overrides the standalone default
      internationalization = {
        supported_locales = ["en", "da", "de"]
        default_locale    = "en"
      }
      create_events = true
      events = {
        admin_events_enabled = true
      }
    }
  }
}
```

## Inputs

- `items` — map of realm objects keyed by a stable logical name. `realm` is
  required per entry; every other field is optional. Untyped (`any`); the
  accepted fields are those of the standalone [`../../`](../../) module.
- `defaults` — map of field values applied to every item unless overridden on
  the entry. `realm` should not be set here (it must be unique).

## Outputs

- `realms` — full map of `{ id, realm, enabled, events_managed }`.
- `realm_ids` — logical key => realm internal ID (equal to the realm name).

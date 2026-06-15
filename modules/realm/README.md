# Keycloak Realm module (standalone)

Manages a **single** `keycloak_realm`, optionally including its realm-wide event
configuration. The realm's `id` output equals the realm name and is what every
other module in this collection (clients, roles, scopes) takes as `realm_id`, so
this module is the root of a realm's resource graph. To manage many realms from
one map, use the [`../realms`](./wrappers/realms) wrapper instead.

## Usage

```hcl
module "internal" {
  source = "../realm"

  realm        = "internal"
  display_name = "Example Internal"

  # Login policy
  registration_allowed = false
  verify_email         = true
  reset_password_allowed = true
  ssl_required         = "all"

  # Sessions
  sso_session_idle_timeout = "30m"
  sso_session_max_lifespan = "10h"

  password_policy = "upperCase(1) and lowerCase(1) and digits(1) and length(12) and notUsername"

  internationalization = {
    supported_locales = ["en", "da"]
    default_locale    = "en"
  }

  security_defenses = {
    brute_force_detection = {
      max_login_failures = 20
      permanent_lockout  = false
    }
  }

  create_events = true
  events = {
    admin_events_enabled         = true
    admin_events_details_enabled = true
  }
}
```

## Realm ID as the cross-reference key

`keycloak_realm` uses the realm **name** as its resource `id`. Downstream modules
never depend on this module's state directly — they accept a `realm_id` string.
Wire them together by passing this module's `id` output:

```hcl
module "internal" {
  source = "../realm"
  realm  = "internal"
}

module "dashboard" {
  source   = "../client"
  realm_id = module.internal.id
  client_id = "dashboard"
}
```

## Event configuration

Realm event/audit logging lives in a separate `keycloak_realm_events` singleton.
It is gated behind `create_events` so realms that don't opt in leave Keycloak's
event settings untouched. When enabled, configure it through the `events` object.

## Defaults & security posture

| Variable | Default | Rationale |
| --- | --- | --- |
| `registration_allowed` | `false` | no self-registration unless intended |
| `edit_username_allowed` | `false` | usernames are immutable by default |
| `verify_email` | `true` | confirm ownership of the email address |
| `ssl_required` | `external` | require HTTPS for external requests |
| `duplicate_emails_allowed` | `false` | one account per email |
| `create_events` | `false` | don't touch event config unless opted in |

See `variables.tf` for the full input schema.

## Outputs

- `id` — realm internal ID (equal to the realm name); pass as `realm_id` downstream.
- `realm` — the realm name.
- `enabled` — whether the realm is enabled.
- `events_managed` — whether this module manages event configuration.

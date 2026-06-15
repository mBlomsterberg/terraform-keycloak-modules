# Keycloak OpenID Client module (standalone)

Manages a **single** `keycloak_openid_client`. Realm membership is injected via
`realm_id`, so the module is decoupled from realm state and reusable across every
realm. To manage many clients from one map, use the [`../clients`](../clients)
wrapper instead.

## Usage

```hcl
data "keycloak_realm" "internal" {
  realm = "internal"
}

module "dashboard" {
  source = "../client"

  realm_id    = data.keycloak_realm.internal.id
  client_id   = "dashboard"
  name        = "Dashboard"
  access_type = "CONFIDENTIAL"

  valid_redirect_uris                 = ["https://app.example.com/*"]
  require_dpop_bound_tokens           = true
  backchannel_logout_url              = "https://app.example.com/logout"
  backchannel_logout_session_required = true
}
```

## Scope assignment

Set `default_scopes` and `optional_scopes` to lists of scope names to manage scope assignment for the client. When either variable is set, Terraform becomes the authoritative source for that client's scope list and any manually-added scopes will be removed on the next apply.

```hcl
module "dashboard" {
  source = "../client"
  # ...
  default_scopes  = ["openid", "profile", "email", "roles", "groups"]
  optional_scopes = ["offline_access"]
}
```

Leave both as `null` (the default) to let Keycloak apply the realm's default scope list automatically. Set either to `[]` to explicitly clear all scopes of that type.

> **Note:** Scope names must match existing scopes in the realm. Use `module.<scope>.name` to reference scopes managed by the `openid_client_scope` module.

## Defaults & security posture

| Variable | Default | Rationale |
| --- | --- | --- |
| `access_type` | `CONFIDENTIAL` | server-side clients by default |
| `standard_flow_enabled` | `true` | authorization-code flow |
| `implicit_flow_enabled` | `false` | deprecated, never enable |
| `direct_access_grants_enabled` | `false` | resource-owner password — never in prod |
| `service_accounts_enabled` | `false` | enable only for M2M clients |
| `oauth2_device_authorization_grant_enabled` | `false` | enable only for device flows |
| `pkce_code_challenge_method` | `S256` | recommended even for confidential clients |

See `variables.tf` for the full input schema.

## Outputs

- `id` — internal client UUID.
- `client_id` — the registered client identifier.
- `service_account_user_id` — service-account user ID (when `service_accounts_enabled = true`).
- `resource_server_id` — resource-server ID (when authorization services are enabled).

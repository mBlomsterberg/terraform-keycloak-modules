# Module composition guide

This guide walks through building a complete realm configuration by wiring the modules together. The example constructs an `internal` realm for an engineering platform — a realistic setup that touches every module and shows the patterns for passing outputs between them.

The full wiring at a glance:

```
realm → authentication_flow → (bound to realm)
realm → openid_client_scope  → (name) → client
realm → role                 → (id)   → group, user
realm → group                → (id)   → user
realm → organization         → (id)   → identity_provider
realm → identity_provider
realm → client
realm → user
```

---

## 1. Realm

The realm is the root of every other resource. Its `id` output (which equals the realm name) is passed as `realm_id` to every downstream module.

```hcl
module "internal" {
  source = "path/to/modules/realm"

  realm        = "internal"
  display_name = "Internal Platform"
  ssl_required = "all"
  verify_email = true

  password_policy = "upperCase(1) and lowerCase(1) and digits(1) and length(12) and notUsername"

  smtp_server = {
    host              = "smtp.example.com"
    port              = "587"
    from              = "no-reply@example.com"
    from_display_name = "Example Platform"
    starttls          = true
    auth = {
      username = "smtp-user"
      password = var.smtp_password
    }
  }

  create_events = true
  events = {
    admin_events_enabled         = true
    admin_events_details_enabled = true
  }
}
```

Every other module call below passes `module.internal.id` as `realm_id`.

---

## 2. Authentication flow

Create a custom browser flow before the realm is fully configured, so it can be bound in the next step. The `alias` output is what the realm and clients reference — never the `id`.

```hcl
module "browser_flow" {
  source = "path/to/modules/authentication_flow"

  realm_id    = module.internal.id
  alias       = "browser-with-otp"
  description = "Browser flow with conditional OTP."

  executions = {
    cookie = {
      authenticator = "auth-cookie"
      requirement   = "ALTERNATIVE"
      priority      = 10
    }
    idp_redirect = {
      authenticator = "identity-provider-redirector"
      requirement   = "ALTERNATIVE"
      priority      = 20
    }
  }

  subflows = {
    conditional_otp = {
      alias       = "Conditional OTP"
      provider_id = "basic-flow"
      requirement = "CONDITIONAL"
      priority    = 30
    }
  }
}
```

Bind the flow to the realm by referencing its alias:

```hcl
# Bind the custom flow to the realm after both are created.
# Use a separate keycloak_realm resource or pass browser_flow
# directly if your realm module accepts it.
resource "keycloak_authentication_bindings" "this" {
  realm_id     = module.internal.id
  browser_flow = module.browser_flow.alias
}
```

---

## 3. Roles

Roles are created before groups and users so their IDs are available for assignment.

```hcl
module "viewer" {
  source   = "path/to/modules/role"
  realm_id = module.internal.id
  name     = "viewer"
  description = "Read-only access."
}

module "developer" {
  source   = "path/to/modules/role"
  realm_id = module.internal.id
  name     = "developer"
  description = "Read and write access."
  composite_roles = [module.viewer.id]
}

module "admin" {
  source   = "path/to/modules/role"
  realm_id = module.internal.id
  name     = "admin"
  description = "Full access."
  composite_roles = [module.developer.id]
}
```

---

## 4. OpenID client scopes

Scopes are created before clients so their names are available for `default_scopes` / `optional_scopes` assignment.

```hcl
module "scope_groups" {
  source   = "path/to/modules/openid_client_scope"
  realm_id = module.internal.id
  name     = "groups"
  description = "Adds the user's group memberships as a groups claim."

  group_membership_mappers = {
    groups = {
      claim_name = "groups"
      full_path  = false
    }
  }
}

module "scope_roles" {
  source   = "path/to/modules/openid_client_scope"
  realm_id = module.internal.id
  name     = "roles"
  description = "Adds realm roles to the token."

  user_realm_role_mappers = {
    realm_roles = {
      claim_name  = "realm_access.roles"
      multivalued = true
    }
  }
}
```

---

## 5. Clients

Clients reference scope names with `module.<scope>.name` and optionally override the authentication flow with `authentication_flow_binding_overrides`.

```hcl
module "dashboard" {
  source = "path/to/modules/client"

  realm_id    = module.internal.id
  client_id   = "dashboard"
  name        = "Dashboard"
  access_type = "CONFIDENTIAL"

  valid_redirect_uris = ["https://app.example.com/*"]
  web_origins         = ["https://app.example.com"]

  pkce_code_challenge_method = "S256"

  # Bind the custom browser flow to this client specifically.
  authentication_flow_binding_overrides = {
    browser_id = module.browser_flow.id
  }

  # Reference scopes by name — they must exist before this apply.
  default_scopes  = ["openid", "profile", "email", module.scope_roles.name]
  optional_scopes = ["offline_access", module.scope_groups.name]
}

# Client role — scoped to the dashboard client.
module "role_dashboard_admin" {
  source    = "path/to/modules/role"
  realm_id  = module.internal.id
  client_id = module.dashboard.id
  name      = "dashboard-admin"
}
```

---

## 6. Groups

Groups take role IDs directly. Nest groups by passing `parent_id`.

```hcl
module "group_engineering" {
  source   = "path/to/modules/group"
  realm_id = module.internal.id
  name     = "engineering"
  attributes = { managed_by = "terraform" }
}

module "group_backend" {
  source    = "path/to/modules/group"
  realm_id  = module.internal.id
  name      = "backend"
  parent_id = module.group_engineering.id

  # Everyone in backend gets the developer role.
  role_ids = [module.developer.id]
}

module "group_frontend" {
  source    = "path/to/modules/group"
  realm_id  = module.internal.id
  name      = "frontend"
  parent_id = module.group_engineering.id
  role_ids  = [module.developer.id]
}
```

---

## 7. Organization (optional — Keycloak 26+)

Organizations scope identity providers and groups to a tenant namespace.

```hcl
module "org_acme" {
  source   = "path/to/modules/organization"
  realm_id = module.internal.id
  name     = "acme"
  alias    = "acme"

  domains = {
    "acme.example" = { verified = true }
  }
}
```

---

## 8. Identity provider

Pass `organization_id` to scope the IdP to a tenant. Use `first_broker_login_flow_alias` to run a custom flow on first login.

```hcl
module "idp_google" {
  source = "path/to/modules/identity_provider/modules/google"

  realm_id      = module.internal.id
  alias         = "google"
  display_name  = "Google"
  client_id     = var.google_client_id
  client_secret = var.google_client_secret

  hosted_domain = "example.com"
  trust_email   = true

  # Run the custom browser flow after first broker login.
  first_broker_login_flow_alias = module.browser_flow.alias

  # Scope this IdP to the ACME organisation.
  organization_id              = module.org_acme.id
  org_domain                   = "acme.example"
  org_redirect_mode_email_matches = true

  attribute_importer_mappers = {
    email = {
      user_attribute = "email"
      claim_name     = "email"
    }
  }

  hardcoded_group_mappers = {
    engineering = {
      group = module.group_engineering.path
    }
  }
}
```

---

## 9. Users

Users are last — they reference group and role IDs, both of which must exist first.

```hcl
# Service account bot — direct role assignment.
module "user_ci_bot" {
  source   = "path/to/modules/user"
  realm_id = module.internal.id
  username = "ci-bot"
  email    = "ci-bot@example.com"

  email_verified = true

  initial_password = {
    value     = var.ci_bot_password
    temporary = false
  }

  role_ids = [module.admin.id]
  attributes = { managed_by = "terraform" }
}

# Human engineer — group membership, no direct roles (inherited via group).
module "user_alice" {
  source   = "path/to/modules/user"
  realm_id = module.internal.id
  username = "alice"
  email    = "alice@example.com"

  email_verified = true

  group_ids = [module.group_backend.id]

  federated_identities = {
    google = {
      user_id   = var.alice_google_sub
      user_name = "alice@example.com"
    }
  }
}
```

---

## Output wiring reference

The table below shows which output from each module is consumed as which input by downstream modules.

| Producer | Output | Consumer | Input |
|---|---|---|---|
| `realm` | `id` | all modules | `realm_id` |
| `authentication_flow` | `id` | `client` | `authentication_flow_binding_overrides.browser_id` |
| `authentication_flow` | `alias` | `realm` binding, `identity_provider` | `browser_flow`, `first_broker_login_flow_alias` |
| `openid_client_scope` | `name` | `client` | `default_scopes`, `optional_scopes` |
| `role` | `id` | `role` (composites), `group`, `user` | `composite_roles`, `role_ids`, `role_ids` |
| `client` | `id` | `role` | `client_id` (client-scoped roles) |
| `group` | `id` | `user`, `organization_id` on sub-resources | `group_ids` |
| `group` | `path` | `identity_provider` mapper | `group` in `hardcoded_group_mappers` |
| `organization` | `id` | `group`, `identity_provider` | `organization_id` |

---

## Apply order

Terraform resolves the dependency graph automatically from the `module.X.output` references — you do not need to apply modules manually in sequence. The only practical exception is **parent/child groups in the same wrapper call**: the parent's ID is unknown at plan time, so split parent and child groups into separate module calls or separate `terraform apply` passes.

```hcl
# First apply creates the parent.
module "group_engineering" { ... }

# Second apply (or same root, separate call) can reference the parent.
module "group_backend" {
  parent_id = module.group_engineering.id
  ...
}
```

All other inter-module references (scope names, role IDs, flow aliases, org IDs) are resolved within a single `terraform apply`.

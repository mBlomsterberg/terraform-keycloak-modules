# Module overview

This repository provides a collection of standalone Terraform modules for managing Keycloak resources. Each module manages one logical Keycloak concept and exposes outputs that neighbouring modules consume as inputs.

---

## Module catalogue

### `realm`

Manages a Keycloak realm and its event configuration.

| | |
|---|---|
| **Resources** | `keycloak_realm`, `keycloak_realm_events` |
| **Key inputs** | `realm`, `display_name`, `ssl_required`, `smtp_server`, `password_policy`, `security_defenses` |
| **Key outputs** | `id` (equals the realm name — passed as `realm_id` to every other module) |
| **Depends on** | — |

---

### `authentication_flow`

Manages a custom authentication flow and its executions, execution configs, and subflows.

| | |
|---|---|
| **Resources** | `keycloak_authentication_flow`, `keycloak_authentication_execution`, `keycloak_authentication_execution_config`, `keycloak_authentication_subflow` |
| **Key inputs** | `realm_id`, `alias`, `provider_id`, `executions` (map), `subflows` (map) |
| **Key outputs** | `id`, `alias` (bind to realm or client via the alias) |
| **Depends on** | `realm` |

---

### `openid_client_scope`

Manages an OpenID Connect client scope and its protocol mappers. Scopes are realm-level resources shared across many clients.

| | |
|---|---|
| **Resources** | `keycloak_openid_client_scope`, `keycloak_openid_user_attribute_protocol_mapper`, `keycloak_openid_user_property_protocol_mapper`, `keycloak_openid_group_membership_protocol_mapper`, `keycloak_openid_user_realm_role_protocol_mapper`, `keycloak_openid_user_client_role_protocol_mapper`, `keycloak_openid_audience_protocol_mapper`, `keycloak_openid_hardcoded_claim_protocol_mapper`, `keycloak_openid_full_name_protocol_mapper` |
| **Key inputs** | `realm_id`, `name`, `*_mappers` (maps — one per mapper type) |
| **Key outputs** | `id`, `name` (clients reference scopes by name) |
| **Depends on** | `realm` |

---

### `client`

Manages a single Keycloak OpenID Connect client and its scope assignments.

| | |
|---|---|
| **Resources** | `keycloak_openid_client`, `keycloak_openid_client_default_scopes`, `keycloak_openid_client_optional_scopes` |
| **Key inputs** | `realm_id`, `client_id`, `access_type`, `valid_redirect_uris`, `default_scopes`, `optional_scopes`, `authentication_flow_binding_overrides` |
| **Key outputs** | `id`, `client_id`, `service_account_user_id`, `resource_server_id` |
| **Depends on** | `realm`; optionally `openid_client_scope` (for scope names), `authentication_flow` (for flow binding overrides) |

---

### `role`

Manages a single Keycloak role — either a realm role or a client role.

| | |
|---|---|
| **Resources** | `keycloak_role` |
| **Key inputs** | `realm_id`, `name`, `client_id` (omit for realm roles), `composite_roles` |
| **Key outputs** | `id`, `name` |
| **Depends on** | `realm`; optionally `client` (for client-scoped roles) |

---

### `group`

Manages a Keycloak group with optional role assignments, user memberships, and fine-grained admin permissions.

| | |
|---|---|
| **Resources** | `keycloak_group`, `keycloak_group_roles`, `keycloak_group_memberships`, `keycloak_group_permissions` |
| **Key inputs** | `realm_id`, `name`, `parent_id`, `organization_id`, `role_ids`, `members`, `create_permissions` |
| **Key outputs** | `id`, `name`, `path` |
| **Depends on** | `realm`; optionally `role` (for `role_ids`), `organization` (for org-scoped groups) |

---

### `organization`

Manages a Keycloak organization (multi-tenant, requires Keycloak 26+) with its email domain associations.

| | |
|---|---|
| **Resources** | `keycloak_organization` |
| **Key inputs** | `realm_id`, `name`, `alias`, `domains` (map keyed by domain name) |
| **Key outputs** | `id`, `name`, `alias` |
| **Depends on** | `realm` |

---

### `identity_provider`

Manages an identity provider (IdP) and its attribute/role/group mappers. Sub-modules cover Google, GitHub, Microsoft, and SAML.

| | |
|---|---|
| **Root resource** | `keycloak_oidc_identity_provider` |
| **Sub-modules** | `modules/google`, `modules/github`, `modules/microsoft`, `modules/saml` |
| **Mapper resources** | `keycloak_attribute_importer_identity_provider_mapper`, `keycloak_attribute_to_role_identity_provider_mapper`, `keycloak_hardcoded_role_identity_provider_mapper`, `keycloak_hardcoded_attribute_identity_provider_mapper`, `keycloak_hardcoded_group_identity_provider_mapper`, `keycloak_user_template_importer_identity_provider_mapper`, `keycloak_custom_identity_provider_mapper` |
| **Key inputs** | `realm_id`, `alias`, `client_id`, `client_secret`, `authorization_url`, `token_url`, `*_mappers` (maps) |
| **Key outputs** | `id`, `alias`, `internal_id` |
| **Depends on** | `realm`; optionally `organization` (for org-scoped IdPs), `authentication_flow` (for first/post broker flows) |

---

### `user`

Manages a Keycloak user with an optional initial password, federated identity links, group membership, and role assignments.

| | |
|---|---|
| **Resources** | `keycloak_user`, `keycloak_user_groups`, `keycloak_user_roles` |
| **Key inputs** | `realm_id`, `username`, `email`, `initial_password`, `federated_identities`, `group_ids`, `role_ids` |
| **Key outputs** | `id`, `username` |
| **Depends on** | `realm`; optionally `group` (for `group_ids`), `role` (for `role_ids`) |

---

## Dependency graph

```
realm
│
├── authentication_flow ──────────────────────────────────┐
│                                                         │
├── openid_client_scope                                   │
│         │                                               │
│         └─(name)──► client ◄──(alias)──────────────────┘
│
├── role ──────────────────────────────────┐
│                                          │
├── organization                           │
│         │                               │
│         └─(id)──► group ◄──(id)─────────┤
│         │               │               │
│         └─(id)──► identity_provider     │
│                                         │
└── user ◄────────────(id)────────────────┘
      ◄──────────────(id)──── group
```

**Reading the graph:** an arrow `A ──(x)──► B` means module B takes the output `x` from module A as an input. All modules except `realm` also take `realm.id` as `realm_id` — that edge is omitted to avoid clutter.

---

## Wrapper sub-modules

Every module ships a wrapper at `wrappers/<plural>/` that creates many instances from a single `items` map. Values resolve via `try(each.value.X, var.defaults.X, <fallback>)` — per-item values win over shared defaults, and the standalone module's own defaults apply last.

| Module | Wrapper path |
|---|---|
| `realm` | `modules/realm/wrappers/realms/` |
| `client` | `modules/client/wrappers/clients/` |
| `role` | `modules/role/wrappers/roles/` |
| `authentication_flow` | `modules/authentication_flow/wrappers/flows/` |
| `openid_client_scope` | `modules/openid_client_scope/wrappers/scopes/` |
| `group` | `modules/group/wrappers/groups/` |
| `organization` | `modules/organization/wrappers/organizations/` |
| `identity_provider` | `modules/identity_provider/wrappers/identity_providers/` |
| `user` | `modules/user/wrappers/users/` |

---

## Version requirements

All modules require **Terraform ≥ 1.3** (needed for `optional()` with defaults in object type constraints) and **keycloak provider ≥ 5.7.0**.

# Keycloak Authentication Flow Terraform module

Terraform module which creates Keycloak authentication flow resources.

## Usage

See the [`examples/`](./examples) directory for working configurations. A minimal call creating a custom browser flow:

```hcl
module "browser_flow" {
  source = "path/to/modules/authentication_flow"

  realm_id    = data.keycloak_realm.this.id
  alias       = "custom-browser"
  description = "Custom browser flow: cookie, IdP redirect, conditional OTP."

  executions = {
    cookie = {
      authenticator = "auth-cookie"
      requirement   = "ALTERNATIVE"
      priority      = 10
    }
    identity_provider_redirector = {
      authenticator = "identity-provider-redirector"
      requirement   = "ALTERNATIVE"
      priority      = 25
      config = {
        alias = "idp-redirector-config"
        config = {
          defaultProvider = "google"
        }
      }
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

## Executions

The `executions` variable is a **map of objects** keyed by a stable logical name. The key becomes the Terraform resource identifier and the cross-reference key for `execution_ids` in the outputs. Each execution may optionally carry a `config` block for authenticators that require extra configuration (e.g. `identity-provider-redirector` needs a `defaultProvider`).

```hcl
executions = {
  idp_redirect = {
    authenticator = "identity-provider-redirector"
    requirement   = "ALTERNATIVE"
    priority      = 25
    config = {
      alias  = "idp-config"
      config = { defaultProvider = "google" }
    }
  }
}
```

Access the generated UUID via `module.browser_flow.execution_ids["idp_redirect"]`.

## Subflows

The `subflows` variable is a **map of objects** that creates nested `keycloak_authentication_subflow` resources under the parent flow. Subflows are commonly used for conditional branches (e.g. prompting for OTP only when the `condition-user-configured` condition is met).

```hcl
subflows = {
  conditional_otp = {
    alias       = "Conditional OTP"
    provider_id = "basic-flow"
    requirement = "CONDITIONAL"
    priority    = 30
  }
}
```

> **Note:** Executions *inside* a subflow must be managed outside this module (or in a second module call) using `parent_flow_alias = module.browser_flow.subflow_ids["conditional_otp"]` — the provider requires the subflow's flow ID, not its alias, for child executions.

## Binding flows to a realm or client

After creating a flow, bind it by passing its alias to `keycloak_realm` or to the `authentication_flow_binding_overrides` block on a `keycloak_openid_client`:

```hcl
resource "keycloak_realm" "this" {
  realm            = "my-realm"
  browser_flow     = module.browser_flow.alias
  direct_grant_flow = module.direct_grant_flow.alias
}
```

## Wrapper

To create multiple flows in a single call use the `wrappers/flows` sub-module:

```hcl
module "flows" {
  source = "path/to/modules/authentication_flow/wrappers/flows"

  realm_id = data.keycloak_realm.this.id

  defaults = {
    provider_id = "basic-flow"
  }

  items = {
    browser      = { alias = "custom-browser" }
    direct_grant = { alias = "custom-direct-grant" }
  }
}

# Access: module.flows.wrapper["browser"].alias
```

## Examples

These examples are working reference configurations and a way to validate module changes. They are not intended as opinionated best practices.

- [complete](./examples/complete) — browser, direct-grant, and client-auth flows with executions, execution configs, and subflows.

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

## License

Apache-2.0 Licensed. See [LICENSE](../../LICENSE).

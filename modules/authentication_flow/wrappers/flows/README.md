# Keycloak Authentication Flow — flows wrapper

Creates multiple `authentication_flow` module instances from a single map, following the [terraform-aws-modules wrapper convention](https://github.com/terraform-aws-modules).

## Usage

```hcl
module "flows" {
  source = "path/to/modules/authentication_flow/wrappers/flows"

  realm_id = data.keycloak_realm.this.id

  defaults = {
    provider_id = "basic-flow"
  }

  items = {
    browser = {
      alias       = "custom-browser"
      description = "Custom browser authentication flow."
      executions = {
        cookie = {
          authenticator = "auth-cookie"
          requirement   = "ALTERNATIVE"
          priority      = 10
        }
      }
    }
    direct_grant = {
      alias       = "custom-direct-grant"
      description = "Custom direct-grant authentication flow."
    }
  }
}
```

## Outputs

| Name | Description |
|------|-------------|
| `wrapper` | Map of all managed `authentication_flow` module instances keyed by `var.items` key. Access individual attributes via `module.flows.wrapper["browser"].id`. |

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

Apache-2.0 Licensed. See [LICENSE](../../../../LICENSE).

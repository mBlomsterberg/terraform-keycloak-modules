# Keycloak Organization — organizations wrapper

Creates multiple `organization` module instances from a single map, following the [terraform-aws-modules wrapper convention](https://github.com/terraform-aws-modules).

## Usage

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
```

## Outputs

| Name | Description |
|------|-------------|
| `wrapper` | Map of all managed `organization` module instances keyed by `var.items` key. Access individual attributes via `module.orgs.wrapper["acme"].id`. |

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

Apache-2.0 Licensed. See [LICENSE](../../../../LICENSE).

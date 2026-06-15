# Complete example — Keycloak Authentication Flow module

Configuration in this directory creates:

- A custom **browser** authentication flow with cookie, IdP redirector (with default-provider config), and a conditional OTP subflow
- A custom **direct-grant** flow with username/password validation
- A custom **client** authentication flow using client-secret

These examples serve two purposes: working reference configurations and a way to validate module changes. They are not intended as opinionated best practices.

## Usage

```bash
terraform init
terraform plan
terraform apply
```

> **Cost:** Keycloak itself is self-hosted — there is no cloud cost for these resources. Run `terraform destroy` to remove all created flows when you are done.

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

Apache-2.0 Licensed. See [LICENSE](../../../../LICENSE).

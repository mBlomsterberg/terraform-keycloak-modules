################################################################################
# Keycloak roles wrapper — input variables
# Provider: keycloak/keycloak >= 5.7.0
#
# Follows the terraform-aws-modules wrapper convention: `items` and `defaults`
# are untyped maps, and each argument resolves via
# try(each.value.X, var.defaults.X, null). The null fallback makes the standalone
# ../../ role module apply its own default, so defaults live in one place only.
################################################################################

variable "realm_id" {
  description = "Internal ID of the Keycloak realm these roles belong to (e.g. data.keycloak_realm.this.id)."
  type        = string
}

variable "items" {
  description = "Map of role definitions to create, keyed by a stable logical name. Each value is passed through to the ../../ role module; `name` is required per item, every other field is optional. In `composite_roles`, an entry matching another item's key is resolved to that sibling's role ID."
  type        = any
  default     = {}
}

variable "defaults" {
  description = "Map of default values applied to each item in `var.items` unless overridden on the item. `name` should not be set here — it must be unique per role."
  type        = any
  default     = {}
}

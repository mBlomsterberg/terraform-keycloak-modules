################################################################################
# Keycloak OpenID clients wrapper — input variables
# Provider: keycloak/keycloak >= 5.7.0
#
# Follows the terraform-aws-modules wrapper convention: `items` and `defaults`
# are untyped maps, and each argument resolves via
# try(each.value.X, var.defaults.X, null). The null fallback makes the standalone
# ../../ client module apply its own (secure) default, so defaults live in one
# place only.
################################################################################

variable "realm_id" {
  description = "Internal ID of the Keycloak realm these clients belong to (e.g. data.keycloak_realm.this.id)."
  type        = string
}

variable "items" {
  description = "Map of OpenID client definitions to create, keyed by a stable logical name. Each value is passed through to the ../../ client module; `client_id` is required per item, every other field is optional."
  type        = any
  default     = {}
}

variable "defaults" {
  description = "Map of default values applied to each item in `var.items` unless overridden on the item. `client_id` should not be set here — it must be unique per client."
  type        = any
  default     = {}
}

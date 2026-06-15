################################################################################
# Keycloak realms wrapper — input variables
# Provider: keycloak/keycloak >= 5.7.0
#
# Follows the terraform-aws-modules wrapper convention: `items` and `defaults`
# are untyped maps, and each argument resolves via
# try(each.value.X, var.defaults.X, null). The null fallback makes the standalone
# ../../ realm module apply its own (secure) default, so defaults live in one
# place only.
################################################################################

variable "items" {
  description = "Map of realm definitions to create, keyed by a stable logical name. Each value is passed through to the ../../ realm module; `realm` is required per item, every other field is optional."
  type        = any
  default     = {}
}

variable "defaults" {
  description = "Map of default values applied to each item in `var.items` unless overridden on the item. `realm` should not be set here — it must be unique per realm."
  type        = any
  default     = {}
}

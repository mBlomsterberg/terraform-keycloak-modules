################################################################################
# Keycloak authentication flows wrapper — input variables
################################################################################

variable "realm_id" {
  description = "Internal ID of the Keycloak realm all flows in this wrapper belong to."
  type        = string
}

variable "items" {
  description = "Map of authentication flow definitions to create, keyed by a stable logical name. Each value is passed through to the ../../ authentication_flow module; `alias` is required per item, every other field is optional."
  type        = any
  default     = {}
}

variable "defaults" {
  description = "Map of default values applied to each item in `var.items` unless overridden on the item. `alias` must not be set here — it must be unique per flow."
  type        = any
  default     = {}
}

################################################################################
# Keycloak OpenID client scopes wrapper — input variables
################################################################################

variable "realm_id" {
  description = "Internal ID of the Keycloak realm all scopes in this wrapper belong to."
  type        = string
}

variable "items" {
  description = "Map of client scope definitions to create, keyed by a stable logical name. Each value is passed through to the ../../ openid_client_scope module; `name` is required per item, every other field is optional."
  type        = any
  default     = {}
}

variable "defaults" {
  description = "Map of default values applied to each item in var.items unless overridden on the item. `name` must not be set here — it must be unique per scope."
  type        = any
  default     = {}
}

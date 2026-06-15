################################################################################
# Keycloak organizations wrapper — input variables
################################################################################

variable "realm_id" {
  description = "Internal ID of the Keycloak realm all organizations in this wrapper belong to."
  type        = string
}

variable "items" {
  description = "Map of organization definitions to create, keyed by a stable logical name. Each value is passed through to the ../../ organization module; `name` is required per item, every other field is optional."
  type        = any
  default     = {}
}

variable "defaults" {
  description = "Map of default values applied to each item in var.items unless overridden on the item. `name` and `alias` must not be set here — they must be unique per organization."
  type        = any
  default     = {}
}

################################################################################
# Keycloak groups wrapper — input variables
################################################################################

variable "realm_id" {
  description = "Internal ID of the Keycloak realm all groups in this wrapper belong to."
  type        = string
}

variable "items" {
  description = "Map of group definitions to create, keyed by a stable logical name. Each value is passed through to the ../../ group module; `name` is required per item, every other field is optional."
  type        = any
  default     = {}
}

variable "defaults" {
  description = "Map of default values applied to each item in var.items unless overridden on the item. `name` must not be set here — it must be unique per group."
  type        = any
  default     = {}
}

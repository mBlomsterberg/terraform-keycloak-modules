################################################################################
# Keycloak identity providers wrapper — input variables
################################################################################

variable "realm_id" {
  description = "Internal ID of the Keycloak realm all identity providers in this wrapper belong to."
  type        = string
}

variable "items" {
  description = "Map of identity provider definitions to create, keyed by a stable logical name. Each value is passed through to the ../../ identity_provider module; `alias`, `authorization_url`, `client_id`, and `token_url` are required per item. Every other field is optional and falls back to var.defaults then the module default."
  type        = any
  default     = {}
}

variable "defaults" {
  description = "Map of default values applied to each item in var.items unless overridden on the item. `alias`, `authorization_url`, `client_id`, and `token_url` must not be set here — they must be unique or specific per provider."
  type        = any
  default     = {}
}

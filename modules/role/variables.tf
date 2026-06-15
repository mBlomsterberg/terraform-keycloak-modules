################################################################################
# Standalone Keycloak role module — input variables
# Provider: keycloak/keycloak >= 5.7.0
#
# Manages a single keycloak_role. Use ../roles to manage many at once.
################################################################################

variable "realm_id" {
  description = "Internal ID of the Keycloak realm this role belongs to (e.g. data.keycloak_realm.this.id)."
  type        = string
}

variable "name" {
  description = "The name of the role."
  type        = string
}

variable "client_id" {
  description = "Internal ID of the client to scope this role to (a client role). Leave null to create a realm role."
  type        = string
  default     = null
}

variable "description" {
  description = "Human-readable description of the role."
  type        = string
  default     = null
}

variable "composite_roles" {
  description = "List of already-resolved role IDs this role aggregates (making it a composite role). Empty/null creates a plain role."
  type        = list(string)
  default     = null
}

variable "attributes" {
  description = "Arbitrary role attributes (map of string keys to string values)."
  type        = map(string)
  default     = null
}

variable "create" {
  description = "Whether to create the organization and all related resources."
  type        = bool
  default     = true
}

variable "realm_id" {
  description = "Internal ID of the Keycloak realm this organization belongs to (e.g. data.keycloak_realm.this.id)."
  type        = string
}

variable "name" {
  description = "Display name of the organization. Must be unique within the realm."
  type        = string
}

variable "alias" {
  description = "Unique alias for the organization. Defaults to the name when omitted. Cannot be changed after creation — changing this forces resource replacement."
  type        = string
  default     = null
}

variable "enabled" {
  description = "Whether the organization is active. Disabled organizations are hidden from users."
  type        = bool
  default     = true
}

variable "description" {
  description = "Human-readable description of the organization."
  type        = string
  default     = null
}

variable "redirect_url" {
  description = "URL users are redirected to after registration or invitation acceptance. Defaults to the Keycloak account console when omitted."
  type        = string
  default     = null
}

variable "attributes" {
  description = "Map of organization attributes. Separate multiple values for the same key with \"##\" (e.g. \"value1##value2\"). Values are limited to 255 characters each."
  type        = map(string)
  default     = {}
}

# ── Domains ────────────────────────────────────────────────────────────────────

variable "domains" {
  description = "Map of email domains associated with this organization, keyed by domain name. Members whose email matches a domain are automatically associated with the organization."
  type = map(object({
    verified = optional(bool, false)
  }))
  default = {}
}

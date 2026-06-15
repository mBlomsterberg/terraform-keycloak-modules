variable "create" {
  description = "Whether to create the client scope and all related resources."
  type        = bool
  default     = true
}

variable "realm_id" {
  description = "Internal ID of the Keycloak realm this scope belongs to (e.g. data.keycloak_realm.this.id)."
  type        = string
}

# ── Scope fields ───────────────────────────────────────────────────────────────

variable "name" {
  description = "Name of the client scope. Clients reference scopes by this name in default_scopes and optional_scopes lists."
  type        = string
}

variable "description" {
  description = "Human-readable description shown in the admin console."
  type        = string
  default     = null
}

variable "consent_screen_text" {
  description = "Text shown on the consent screen when a client with this scope requests authorization. When set, the consent screen is displayed."
  type        = string
  default     = null
}

variable "include_in_token_scope" {
  description = "When true, the scope name is included in the access token's scp claim and in token introspection."
  type        = bool
  default     = true
}

variable "gui_order" {
  description = "Display order of the scope in the admin console and consent page."
  type        = number
  default     = null
}

variable "extra_config" {
  description = "Map of additional scope-level configuration key/value pairs passed through to Keycloak."
  type        = map(string)
  default     = {}
}

# ── Protocol mappers ───────────────────────────────────────────────────────────

variable "user_attribute_mappers" {
  description = "Map of user-attribute mappers, keyed by mapper name. Maps custom user attributes to token claims."
  type = map(object({
    user_attribute             = string
    claim_name                 = string
    claim_value_type           = optional(string, "String")
    multivalued                = optional(bool, false)
    aggregate_attributes       = optional(bool, false)
    add_to_id_token            = optional(bool, true)
    add_to_access_token        = optional(bool, true)
    add_to_userinfo            = optional(bool, true)
    add_to_token_introspection = optional(bool, true)
  }))
  default = {}
}

variable "user_property_mappers" {
  description = "Map of user-property mappers, keyed by mapper name. Maps built-in user properties (e.g. username, email) to token claims."
  type = map(object({
    user_property       = string
    claim_name          = string
    claim_value_type    = optional(string, "String")
    add_to_id_token     = optional(bool, true)
    add_to_access_token = optional(bool, true)
    add_to_userinfo     = optional(bool, true)
  }))
  default = {}
}

variable "group_membership_mappers" {
  description = "Map of group-membership mappers, keyed by mapper name. Adds the user's group memberships as a token claim."
  type = map(object({
    claim_name          = string
    full_path           = optional(bool, true)
    add_to_id_token     = optional(bool, true)
    add_to_access_token = optional(bool, true)
    add_to_userinfo     = optional(bool, true)
  }))
  default = {}
}

variable "user_realm_role_mappers" {
  description = "Map of user-realm-role mappers, keyed by mapper name. Adds the user's realm role assignments as a token claim."
  type = map(object({
    claim_name                 = string
    claim_value_type           = optional(string, "String")
    multivalued                = optional(bool, true)
    realm_role_prefix          = optional(string)
    add_to_id_token            = optional(bool, true)
    add_to_access_token        = optional(bool, true)
    add_to_userinfo            = optional(bool, true)
    add_to_token_introspection = optional(bool, true)
  }))
  default = {}
}

variable "user_client_role_mappers" {
  description = "Map of user-client-role mappers, keyed by mapper name. Adds the user's role assignments for a specific client as a token claim."
  type = map(object({
    claim_name                  = string
    claim_value_type            = optional(string, "String")
    multivalued                 = optional(bool, true)
    client_id_for_role_mappings = optional(string)
    client_role_prefix          = optional(string)
    add_to_id_token             = optional(bool, true)
    add_to_access_token         = optional(bool, true)
    add_to_userinfo             = optional(bool, true)
  }))
  default = {}
}

variable "audience_mappers" {
  description = "Map of audience mappers, keyed by mapper name. Adds an entry to the token's aud claim. Set either included_client_audience or included_custom_audience, not both."
  type = map(object({
    included_client_audience = optional(string)
    included_custom_audience = optional(string)
    add_to_id_token          = optional(bool, true)
    add_to_access_token      = optional(bool, true)
  }))
  default = {}
}

variable "hardcoded_claim_mappers" {
  description = "Map of hardcoded-claim mappers, keyed by mapper name. Inserts a fixed claim name/value pair into every token for this scope."
  type = map(object({
    claim_name          = string
    claim_value         = string
    claim_value_type    = optional(string, "String")
    add_to_id_token     = optional(bool, true)
    add_to_access_token = optional(bool, true)
    add_to_userinfo     = optional(bool, true)
  }))
  default = {}
}

variable "full_name_mappers" {
  description = "Map of full-name mappers, keyed by mapper name. Adds the user's full name (firstName + lastName) as the \"name\" claim."
  type = map(object({
    add_to_id_token     = optional(bool, true)
    add_to_access_token = optional(bool, true)
    add_to_userinfo     = optional(bool, true)
  }))
  default = {}
}

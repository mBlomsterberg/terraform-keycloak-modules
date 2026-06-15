variable "create" {
  description = "Whether to create the group and all related resources."
  type        = bool
  default     = true
}

variable "realm_id" {
  description = "Internal ID of the Keycloak realm this group belongs to (e.g. data.keycloak_realm.this.id)."
  type        = string
}

variable "name" {
  description = "Display name of the group."
  type        = string
}

variable "parent_id" {
  description = "ID of the parent group. Omit to create a top-level (root) group."
  type        = string
  default     = null
}

variable "organization_id" {
  description = "ID of the Keycloak organization this group belongs to (requires Keycloak 26.6+). Omit for standard realm groups."
  type        = string
  default     = null
}

variable "attributes" {
  description = "Map of group attributes. Separate multiple values for the same key with \"##\" (e.g. \"value1##value2\")."
  type        = map(string)
  default     = {}
}

# ── Membership ─────────────────────────────────────────────────────────────────

variable "members" {
  description = "List of usernames to assign as members of this group. A keycloak_group_memberships resource is created when this list is non-empty. Do not use alongside keycloak_default_groups for the same group."
  type        = list(string)
  default     = []
}

# ── Role assignments ───────────────────────────────────────────────────────────

variable "role_ids" {
  description = "List of role IDs (realm or client roles) to assign to this group. A keycloak_group_roles resource is created when this list is non-empty."
  type        = list(string)
  default     = []
}

variable "roles_exhaustive" {
  description = "When true, any roles assigned to the group outside of Terraform will be removed on the next apply. Set to false to allow multiple partial role-assignment resources for the same group."
  type        = bool
  default     = true
}

# ── Fine-grained permissions ───────────────────────────────────────────────────

variable "create_permissions" {
  description = "Enable fine-grained admin permissions for this group (keycloak_group_permissions). Requires the admin_fine_grained_authz preview feature in Keycloak."
  type        = bool
  default     = false
}

variable "permissions" {
  description = "Policy configuration for each admin permission scope. Only evaluated when create_permissions = true. Omitting a scope leaves it unconfigured (no policy restriction)."
  type = object({
    view = optional(object({
      policies          = optional(list(string), [])
      description       = optional(string)
      decision_strategy = optional(string, "UNANIMOUS")
    }))
    manage = optional(object({
      policies          = optional(list(string), [])
      description       = optional(string)
      decision_strategy = optional(string, "UNANIMOUS")
    }))
    view_members = optional(object({
      policies          = optional(list(string), [])
      description       = optional(string)
      decision_strategy = optional(string, "UNANIMOUS")
    }))
    manage_members = optional(object({
      policies          = optional(list(string), [])
      description       = optional(string)
      decision_strategy = optional(string, "UNANIMOUS")
    }))
    manage_membership = optional(object({
      policies          = optional(list(string), [])
      description       = optional(string)
      decision_strategy = optional(string, "UNANIMOUS")
    }))
  })
  default = null
}

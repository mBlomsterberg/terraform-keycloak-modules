variable "create" {
  description = "Whether to create the user and all related resources."
  type        = bool
  default     = true
}

variable "realm_id" {
  description = "Internal ID of the Keycloak realm this user belongs to (e.g. data.keycloak_realm.this.id)."
  type        = string
}

# ── Core user fields ───────────────────────────────────────────────────────────

variable "username" {
  description = "Unique username for the user within the realm."
  type        = string
}

variable "enabled" {
  description = "When false, the user cannot log in."
  type        = bool
  default     = true
}

variable "email" {
  description = "Email address of the user."
  type        = string
  default     = null
}

variable "email_verified" {
  description = "When true, the email address is marked as verified without requiring the user to complete the verification flow."
  type        = bool
  default     = false
}

variable "first_name" {
  description = "User's first name."
  type        = string
  default     = null
}

variable "last_name" {
  description = "User's last name."
  type        = string
  default     = null
}

variable "attributes" {
  description = "Map of user attributes. Separate multiple values for the same key with \"##\" (e.g. \"value1##value2\"). Values are limited to 255 characters each."
  type        = map(string)
  default     = {}
}

variable "required_actions" {
  description = "List of required actions the user must complete on next login (e.g. [\"UPDATE_PASSWORD\", \"VERIFY_EMAIL\"])."
  type        = list(string)
  default     = []
}

variable "import_existing" {
  description = "When true, Keycloak assumes a user with this username already exists and imports it into state rather than creating a new one. Useful for bootstrapping pre-existing accounts."
  type        = bool
  default     = false
}

# ── Initial password ───────────────────────────────────────────────────────────

variable "initial_password" {
  description = "Initial password to set on user creation. The password is not managed after the first apply — use required_actions = [\"UPDATE_PASSWORD\"] to force a reset on first login."
  type = object({
    value     = string
    temporary = optional(bool, true)
  })
  sensitive = true
  default   = null
}

# ── Federated identities ───────────────────────────────────────────────────────

variable "federated_identities" {
  description = "Map of federated identity links for this user, keyed by identity provider alias. Links a Keycloak user to an account in an external identity provider."
  type = map(object({
    user_id   = string
    user_name = string
  }))
  default = {}
}

# ── Group membership ───────────────────────────────────────────────────────────

variable "group_ids" {
  description = "List of group IDs to assign this user to. A keycloak_user_groups resource is created when this list is non-empty."
  type        = list(string)
  default     = []
}

variable "groups_exhaustive" {
  description = "When true, any group memberships not listed in group_ids that were added manually will be removed on the next apply. Set to false to allow partial group-assignment resources for the same user."
  type        = bool
  default     = true
}

# ── Role assignments ───────────────────────────────────────────────────────────

variable "role_ids" {
  description = "List of role IDs (realm or client roles) to assign to this user. A keycloak_user_roles resource is created when this list is non-empty."
  type        = list(string)
  default     = []
}

variable "roles_exhaustive" {
  description = "When true, any roles not listed in role_ids that were added manually will be removed on the next apply. Set to false to allow partial role-assignment resources for the same user."
  type        = bool
  default     = true
}

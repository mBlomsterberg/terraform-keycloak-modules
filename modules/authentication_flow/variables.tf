variable "create" {
  description = "Whether to create the authentication flow and all related resources."
  type        = bool
  default     = true
}

variable "realm_id" {
  description = "Internal ID of the Keycloak realm this flow belongs to (e.g. data.keycloak_realm.this.id)."
  type        = string
}

variable "alias" {
  description = "Unique alias identifying this authentication flow within the realm."
  type        = string
}

variable "description" {
  description = "Human-readable description of the authentication flow."
  type        = string
  default     = null
}

variable "provider_id" {
  description = "Flow type: \"basic-flow\" for browser/direct-grant flows, \"client-flow\" for client authentication flows."
  type        = string
  default     = "basic-flow"

  validation {
    condition     = contains(["basic-flow", "client-flow"], var.provider_id)
    error_message = "provider_id must be \"basic-flow\" or \"client-flow\"."
  }
}

# ── Executions ─────────────────────────────────────────────────────────────────

variable "executions" {
  description = "Map of authentication executions to add to this flow, keyed by a stable logical name. If an execution requires authenticator-level config (e.g. identity-provider-redirector), set the nested config block."
  type = map(object({
    authenticator = string
    requirement   = optional(string, "DISABLED")
    priority      = optional(number)
    config = optional(object({
      alias  = string
      config = optional(map(string), {})
    }))
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.executions :
      contains(["REQUIRED", "ALTERNATIVE", "OPTIONAL", "CONDITIONAL", "DISABLED"], v.requirement)
    ])
    error_message = "Each execution's requirement must be one of REQUIRED, ALTERNATIVE, OPTIONAL, CONDITIONAL, or DISABLED."
  }
}

# ── Subflows ───────────────────────────────────────────────────────────────────

variable "subflows" {
  description = "Map of nested authentication subflows inside this flow, keyed by a stable logical name. Use subflows for conditional branches (e.g. conditional OTP)."
  type = map(object({
    alias         = string
    description   = optional(string)
    provider_id   = optional(string, "basic-flow")
    authenticator = optional(string)
    requirement   = optional(string, "DISABLED")
    priority      = optional(number)
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.subflows :
      contains(["REQUIRED", "ALTERNATIVE", "OPTIONAL", "CONDITIONAL", "DISABLED"], v.requirement)
    ])
    error_message = "Each subflow's requirement must be one of REQUIRED, ALTERNATIVE, OPTIONAL, CONDITIONAL, or DISABLED."
  }
}

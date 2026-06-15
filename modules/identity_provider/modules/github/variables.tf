variable "create" {
  description = "Whether to create the identity provider and all related resources."
  type        = bool
  default     = true
}

variable "realm_id" {
  description = "Internal ID of the Keycloak realm this identity provider belongs to (e.g. data.keycloak_realm.this.id)."
  type        = string
}

# ── Core identity provider fields ─────────────────────────────────────────────

variable "alias" {
  description = "Unique alias identifying this identity provider within the realm. Defaults to \"github\" if not set."
  type        = string
  default     = "github"
}

variable "display_name" {
  description = "Human-readable display name shown on the Keycloak login page."
  type        = string
  default     = null
}

variable "enabled" {
  description = "When false, the identity provider is disabled and will not appear on the login page."
  type        = bool
  default     = true
}

variable "link_only" {
  description = "When true, the provider can only be used to link existing accounts, not to log in."
  type        = bool
  default     = false
}

variable "hide_on_login_page" {
  description = "When true, the identity provider button is hidden from the login page (only accessible via direct link)."
  type        = bool
  default     = false
}

variable "store_token" {
  description = "When true, tokens received from the provider are stored in the user session."
  type        = bool
  default     = true
}

variable "add_read_token_role_on_create" {
  description = "When true, newly authenticated users are granted the read-token role so they can retrieve their stored provider tokens."
  type        = bool
  default     = false
}

variable "trust_email" {
  description = "When true, email addresses returned by GitHub are trusted without requiring verification."
  type        = bool
  default     = false
}

variable "first_broker_login_flow_alias" {
  description = "Alias of the authentication flow to run the first time a user authenticates through this provider."
  type        = string
  default     = null
}

variable "post_broker_login_flow_alias" {
  description = "Alias of the authentication flow to run after every successful authentication through this provider."
  type        = string
  default     = null
}

variable "sync_mode" {
  description = "User profile synchronisation strategy: IMPORT (first login only) or FORCE (every login)."
  type        = string
  default     = null
}

variable "organization_id" {
  description = "ID of the Keycloak organization to associate with this identity provider (requires Keycloak 26.6+)."
  type        = string
  default     = null
}

variable "org_domain" {
  description = "Domain hint used for organisation-based IdP routing."
  type        = string
  default     = null
}

variable "org_redirect_mode_email_matches" {
  description = "When true, users whose email domain matches org_domain are automatically redirected to this provider."
  type        = bool
  default     = null
}

variable "gui_order" {
  description = "Display order of the provider on the login page (lower numbers appear first)."
  type        = string
  default     = null
}

variable "extra_config" {
  description = "Map of additional provider-level configuration key/value pairs passed through to Keycloak."
  type        = map(string)
  default     = {}
}

# ── OIDC common fields ────────────────────────────────────────────────────────

variable "client_id" {
  description = "GitHub OAuth App client ID."
  type        = string
}

variable "client_secret" {
  description = "GitHub OAuth App client secret. Mutually exclusive with client_secret_wo / client_secret_wo_version."
  type        = string
  sensitive   = true
  default     = null
}

variable "client_secret_wo" {
  description = "Write-only client secret (Terraform >= 1.11). Use together with client_secret_wo_version. Mutually exclusive with client_secret."
  type        = string
  sensitive   = true
  default     = null
}

variable "client_secret_wo_version" {
  description = "Version string for client_secret_wo. Increment to trigger a secret rotation without exposing the value in state."
  type        = string
  default     = null
}

variable "disable_user_info" {
  description = "When true, Keycloak will not call the UserInfo endpoint after obtaining a token."
  type        = bool
  default     = false
}

variable "default_scopes" {
  description = "Space-separated list of OAuth2 scopes to request. Defaults to \"user:email\"."
  type        = string
  default     = "user:email"
}

variable "login_hint" {
  description = "Login hint to pre-populate on the GitHub login page."
  type        = string
  default     = null
}

variable "accepts_prompt_none_forward_from_client" {
  description = "When true, a prompt=none request from a client is forwarded to GitHub rather than handled locally."
  type        = bool
  default     = false
}

# ── GitHub-specific fields ────────────────────────────────────────────────────

variable "base_url" {
  description = "Base URL of the GitHub instance. Override for GitHub Enterprise Server (e.g. \"https://github.example.com\")."
  type        = string
  default     = "https://github.com"
}

variable "api_url" {
  description = "Base URL of the GitHub API. Override for GitHub Enterprise Server (e.g. \"https://github.example.com/api/v3\")."
  type        = string
  default     = "https://api.github.com"
}

variable "github_json_format" {
  description = "When true, user information is retrieved from the GitHub API in JSON format rather than the default format."
  type        = bool
  default     = false
}

# ── Mapper variables ──────────────────────────────────────────────────────────

variable "attribute_importer_mappers" {
  description = "Map of attribute-importer mappers, keyed by mapper name. Maps claims/attributes from the IdP token to Keycloak user attributes."
  type = map(object({
    user_attribute          = string
    claim_name              = optional(string)
    attribute_name          = optional(string)
    attribute_friendly_name = optional(string)
    extra_config            = optional(map(string), {})
  }))
  default = {}
}

variable "attribute_to_role_mappers" {
  description = "Map of attribute-to-role mappers, keyed by mapper name. Grants a Keycloak role when a specific claim or attribute value is present in the IdP assertion."
  type = map(object({
    role                    = string
    claim_name              = optional(string)
    claim_value             = optional(string)
    attribute_name          = optional(string)
    attribute_friendly_name = optional(string)
    attribute_value         = optional(string)
    extra_config            = optional(map(string), {})
  }))
  default = {}
}

variable "hardcoded_role_mappers" {
  description = "Map of hardcoded-role mappers, keyed by mapper name. Unconditionally grants a Keycloak role to every user authenticated through this provider."
  type = map(object({
    role         = optional(string)
    extra_config = optional(map(string), {})
  }))
  default = {}
}

variable "hardcoded_attribute_mappers" {
  description = "Map of hardcoded-attribute mappers, keyed by mapper name. Sets a fixed user or session attribute value for every user authenticated through this provider."
  type = map(object({
    attribute_name  = string
    user_session    = bool
    attribute_value = optional(string)
    extra_config    = optional(map(string), {})
  }))
  default = {}
}

variable "hardcoded_group_mappers" {
  description = "Map of hardcoded-group mappers, keyed by mapper name. Places every user authenticated through this provider into a fixed group."
  type = map(object({
    group        = optional(string)
    extra_config = optional(map(string), {})
  }))
  default = {}
}

variable "user_template_importer_mappers" {
  description = "Map of user-template-importer mappers, keyed by mapper name. Derives a Keycloak username from a template expression (e.g. \"${ALIAS}.${CLAIM.sub}\")."
  type = map(object({
    template     = string
    extra_config = optional(map(string), {})
  }))
  default = {}
}

variable "custom_mappers" {
  description = "Map of custom identity-provider mappers, keyed by mapper name. Use for provider-specific mapper types not covered by the dedicated variables."
  type = map(object({
    identity_provider_mapper = string
    extra_config             = optional(map(string), {})
  }))
  default = {}
}

################################################################################
# Standalone Keycloak OpenID client module — input variables
# Provider: keycloak/keycloak >= 5.7.0
#
# Manages a single keycloak_openid_client. Use ../clients to manage many at once.
################################################################################

variable "realm_id" {
  description = "Internal ID of the Keycloak realm this client belongs to (e.g. data.keycloak_realm.this.id)."
  type        = string
}

variable "client_id" {
  description = "The client identifier registered in Keycloak (the value used by applications)."
  type        = string
}

variable "name" {
  description = "Human-readable display name."
  type        = string
  default     = null
}

variable "description" {
  description = "Human-readable description."
  type        = string
  default     = null
}

variable "enabled" {
  description = "Whether the client is enabled."
  type        = bool
  default     = true
}

variable "access_type" {
  description = "CONFIDENTIAL | PUBLIC | BEARER-ONLY."
  type        = string
  default     = "CONFIDENTIAL"

  validation {
    condition     = contains(["CONFIDENTIAL", "PUBLIC", "BEARER-ONLY"], var.access_type)
    error_message = "access_type must be one of CONFIDENTIAL, PUBLIC, or BEARER-ONLY."
  }
}

variable "client_secret" {
  description = "Client secret for confidential clients. Leave null to let Keycloak generate one."
  type        = string
  default     = null
  sensitive   = true
}

# ── Flows — secure defaults: only authorization-code is enabled ────────────────

variable "standard_flow_enabled" {
  description = "Enable the OAuth2 authorization-code flow."
  type        = bool
  default     = true
}

variable "implicit_flow_enabled" {
  description = "Enable the implicit flow (deprecated — never enable)."
  type        = bool
  default     = false
}

variable "direct_access_grants_enabled" {
  description = "Enable the resource-owner password flow (never use in production)."
  type        = bool
  default     = false
}

variable "service_accounts_enabled" {
  description = "Enable the client_credentials (M2M) service account."
  type        = bool
  default     = false
}

variable "oauth2_device_authorization_grant_enabled" {
  description = "Enable the RFC 8628 device authorization grant."
  type        = bool
  default     = false
}

# ── URIs ───────────────────────────────────────────────────────────────────────

variable "valid_redirect_uris" {
  description = "Allowed redirect URIs."
  type        = list(string)
  default     = null
}

variable "valid_post_logout_redirect_uris" {
  description = "Allowed post-logout redirect URIs."
  type        = list(string)
  default     = null
}

variable "web_origins" {
  description = "Allowed CORS web origins."
  type        = list(string)
  default     = null
}

variable "root_url" {
  description = "Root URL prepended to relative URLs."
  type        = string
  default     = null
}

variable "base_url" {
  description = "Default URL used when Keycloak needs to link to the client."
  type        = string
  default     = null
}

variable "admin_url" {
  description = "Backchannel admin/logout URL."
  type        = string
  default     = null
}

# ── PKCE & DPoP ────────────────────────────────────────────────────────────────

variable "pkce_code_challenge_method" {
  description = "PKCE method: \"S256\", \"plain\", or \"\" to disable."
  type        = string
  default     = "S256"

  validation {
    condition     = contains(["", "plain", "S256"], var.pkce_code_challenge_method)
    error_message = "pkce_code_challenge_method must be \"plain\", \"S256\", or \"\" (disabled)."
  }
}

variable "require_dpop_bound_tokens" {
  description = "Bind tokens to the requesting client instance (DPoP). Null leaves the server default."
  type        = bool
  default     = null
}

# ── Token / session settings (override realm defaults) ─────────────────────────

variable "access_token_lifespan" {
  description = "Access-token lifespan (seconds or Go duration string)."
  type        = string
  default     = null
}

variable "client_session_idle_timeout" {
  description = "Client session idle timeout."
  type        = string
  default     = null
}

variable "client_session_max_lifespan" {
  description = "Client session max lifespan."
  type        = string
  default     = null
}

variable "client_offline_session_idle_timeout" {
  description = "Client offline session idle timeout."
  type        = string
  default     = null
}

variable "client_offline_session_max_lifespan" {
  description = "Client offline session max lifespan."
  type        = string
  default     = null
}

# ── Login / logout ──────────────────────────────────────────────────────────────

variable "login_theme" {
  description = "Login theme override for this client."
  type        = string
  default     = null
}

variable "frontchannel_logout_enabled" {
  description = "Enable front-channel logout."
  type        = bool
  default     = null
}

variable "backchannel_logout_url" {
  description = "Back-channel logout URL."
  type        = string
  default     = null
}

variable "backchannel_logout_session_required" {
  description = "Whether a session ID is required on back-channel logout."
  type        = bool
  default     = null
}

# ── Authentication flow binding overrides (resolved flow IDs) ──────────────────

variable "authentication_flow_binding_overrides" {
  description = "Override the realm's browser/direct-grant flows with already-resolved flow IDs."
  type = object({
    browser_id      = optional(string)
    direct_grant_id = optional(string)
  })
  default = null
}

variable "extra_config" {
  description = "Arbitrary client attributes not modelled as first-class arguments."
  type        = map(string)
  default     = null
}

# ── Scope assignment ───────────────────────────────────────────────────────────

variable "default_scopes" {
  description = "List of scope names to set as default scopes for this client. When set, Terraform becomes the authoritative source for default scope assignment and any manually-added scopes will be removed. Set to null (the default) to leave scope assignment unmanaged. Set to [] to explicitly clear all default scopes."
  type        = list(string)
  default     = null
}

variable "optional_scopes" {
  description = "List of scope names to set as optional scopes for this client. When set, Terraform becomes the authoritative source for optional scope assignment. Set to null (the default) to leave scope assignment unmanaged. Set to [] to explicitly clear all optional scopes."
  type        = list(string)
  default     = null
}

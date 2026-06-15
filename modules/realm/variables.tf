################################################################################
# Standalone Keycloak realm module — input variables
# Provider: keycloak/keycloak >= 5.7.0
#
# Manages a single keycloak_realm. Use ../realms to manage many at once.
################################################################################

variable "realm" {
  description = "The name of the realm. This is the realm identifier used in URLs and as the resource ID."
  type        = string
}

variable "enabled" {
  description = "Whether the realm is enabled."
  type        = bool
  default     = true
}

variable "display_name" {
  description = "Human-readable name shown on the login screen."
  type        = string
  default     = null
}

variable "display_name_html" {
  description = "HTML variant of the display name shown on the login screen."
  type        = string
  default     = null
}

variable "user_managed_access" {
  description = "Enable User-Managed Access (UMA 2.0) for this realm."
  type        = bool
  default     = null
}

variable "attributes" {
  description = "Arbitrary realm attributes not modelled as first-class arguments."
  type        = map(string)
  default     = null
}

# ── Login settings — secure defaults ───────────────────────────────────────────

variable "registration_allowed" {
  description = "Allow users to self-register."
  type        = bool
  default     = false
}

variable "registration_email_as_username" {
  description = "Use the email address as the username on registration."
  type        = bool
  default     = null
}

variable "edit_username_allowed" {
  description = "Allow users to edit their username after registration."
  type        = bool
  default     = false
}

variable "reset_password_allowed" {
  description = "Show the \"forgot password\" link on the login screen."
  type        = bool
  default     = true
}

variable "remember_me" {
  description = "Show the \"remember me\" checkbox on the login screen."
  type        = bool
  default     = false
}

variable "verify_email" {
  description = "Require users to verify their email address."
  type        = bool
  default     = true
}

variable "login_with_email_allowed" {
  description = "Allow users to log in with their email address."
  type        = bool
  default     = true
}

variable "duplicate_emails_allowed" {
  description = "Allow multiple users to share the same email address. Requires login_with_email_allowed = false."
  type        = bool
  default     = false
}

variable "ssl_required" {
  description = "SSL enforcement: \"all\", \"external\" (default), or \"none\"."
  type        = string
  default     = "external"

  validation {
    condition     = contains(["all", "external", "none"], var.ssl_required)
    error_message = "ssl_required must be one of all, external, or none."
  }
}

# ── Themes ─────────────────────────────────────────────────────────────────────

variable "login_theme" {
  description = "Login theme for the realm."
  type        = string
  default     = null
}

variable "account_theme" {
  description = "Account console theme for the realm."
  type        = string
  default     = null
}

variable "admin_theme" {
  description = "Admin console theme for the realm."
  type        = string
  default     = null
}

variable "email_theme" {
  description = "Email theme for the realm."
  type        = string
  default     = null
}

# ── Tokens / sessions (override server defaults) ───────────────────────────────

variable "default_signature_algorithm" {
  description = "Default algorithm used to sign tokens for the realm (e.g. RS256)."
  type        = string
  default     = null
}

variable "revoke_refresh_token" {
  description = "Revoke refresh tokens and issue a new one on each refresh (rotation)."
  type        = bool
  default     = null
}

variable "refresh_token_max_reuse" {
  description = "Maximum number of times a refresh token may be reused before revocation. Requires revoke_refresh_token = true."
  type        = number
  default     = null
}

variable "sso_session_idle_timeout" {
  description = "SSO session idle timeout (seconds or Go duration string)."
  type        = string
  default     = null
}

variable "sso_session_max_lifespan" {
  description = "SSO session max lifespan."
  type        = string
  default     = null
}

variable "sso_session_idle_timeout_remember_me" {
  description = "SSO session idle timeout when \"remember me\" is set."
  type        = string
  default     = null
}

variable "sso_session_max_lifespan_remember_me" {
  description = "SSO session max lifespan when \"remember me\" is set."
  type        = string
  default     = null
}

variable "offline_session_idle_timeout" {
  description = "Offline session idle timeout."
  type        = string
  default     = null
}

variable "offline_session_max_lifespan" {
  description = "Offline session max lifespan. Requires offline_session_max_lifespan_enabled = true."
  type        = string
  default     = null
}

variable "offline_session_max_lifespan_enabled" {
  description = "Enforce a maximum lifespan on offline sessions."
  type        = bool
  default     = null
}

variable "access_token_lifespan" {
  description = "Access-token lifespan."
  type        = string
  default     = null
}

variable "access_token_lifespan_for_implicit_flow" {
  description = "Access-token lifespan for the implicit flow."
  type        = string
  default     = null
}

variable "access_code_lifespan" {
  description = "Lifespan of an authorization code."
  type        = string
  default     = null
}

variable "access_code_lifespan_login" {
  description = "Max time a user has to complete login once started."
  type        = string
  default     = null
}

variable "access_code_lifespan_user_action" {
  description = "Max time a user has to complete login-related actions (e.g. email verification)."
  type        = string
  default     = null
}

variable "action_token_generated_by_user_lifespan" {
  description = "Lifespan of an action token generated by a user request."
  type        = string
  default     = null
}

variable "action_token_generated_by_admin_lifespan" {
  description = "Lifespan of an action token generated by an admin request."
  type        = string
  default     = null
}

variable "oauth2_device_code_lifespan" {
  description = "Lifespan of an OAuth2 device code."
  type        = string
  default     = null
}

variable "oauth2_device_polling_interval" {
  description = "Minimum polling interval (seconds) for the OAuth2 device flow."
  type        = number
  default     = null
}

# ── Password policy ────────────────────────────────────────────────────────────

variable "password_policy" {
  description = "Realm password policy string, e.g. \"upperCase(1) and length(12) and notUsername\". Empty/null leaves no policy."
  type        = string
  default     = null
}

# ── Default client scopes ────────────────────────────────────────────────────

variable "default_default_client_scopes" {
  description = "Default client scopes assigned to every new client."
  type        = list(string)
  default     = null
}

variable "default_optional_client_scopes" {
  description = "Optional client scopes assignable to clients in this realm."
  type        = list(string)
  default     = null
}

# ── SMTP server ──────────────────────────────────────────────────────────────

variable "smtp_server" {
  description = "SMTP configuration for outbound realm email. Null disables the realm SMTP block."
  type = object({
    host                  = string
    port                  = optional(string)
    from                  = string
    from_display_name     = optional(string)
    reply_to              = optional(string)
    reply_to_display_name = optional(string)
    envelope_from         = optional(string)
    ssl                   = optional(bool)
    starttls              = optional(bool)
    auth = optional(object({
      username = string
      password = string
    }))
  })
  default   = null
  sensitive = true
}

# ── Internationalization ─────────────────────────────────────────────────────

variable "internationalization" {
  description = "Locale support for the realm. Null leaves internationalization disabled."
  type = object({
    supported_locales = list(string)
    default_locale    = string
  })
  default = null
}

# ── Security defenses ──────────────────────────────────────────────────────────

variable "security_defenses" {
  description = "Realm security defenses: HTTP response headers and brute-force detection. Null leaves server defaults."
  type = object({
    headers = optional(object({
      x_frame_options                     = optional(string)
      content_security_policy             = optional(string)
      content_security_policy_report_only = optional(string)
      x_content_type_options              = optional(string)
      x_robots_tag                        = optional(string)
      x_xss_protection                    = optional(string)
      strict_transport_security           = optional(string)
      referrer_policy                     = optional(string)
    }))
    brute_force_detection = optional(object({
      permanent_lockout                = optional(bool)
      max_login_failures               = optional(number)
      wait_increment_seconds           = optional(number)
      quick_login_check_milli_seconds  = optional(number)
      minimum_quick_login_wait_seconds = optional(number)
      max_failure_wait_seconds         = optional(number)
      failure_reset_time_seconds       = optional(number)
    }))
  })
  default = null
}

# ── Realm events (optional sub-resource) ───────────────────────────────────────

variable "create_events" {
  description = "Whether to manage the realm's event configuration (keycloak_realm_events)."
  type        = bool
  default     = false
}

variable "events" {
  description = "Realm event/audit configuration. Only applied when create_events = true."
  type = object({
    events_enabled               = optional(bool, true)
    events_expiration            = optional(number)
    admin_events_enabled         = optional(bool, true)
    admin_events_details_enabled = optional(bool, false)
    enabled_event_types          = optional(list(string))
    events_listeners             = optional(list(string), ["jboss-logging"])
  })
  default = {}
}

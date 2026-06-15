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
  description = "Unique alias identifying this identity provider within the realm."
  type        = string
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
  description = "When true, email addresses returned by the SAML IdP are trusted without requiring verification."
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

# ── SAML-required fields ──────────────────────────────────────────────────────

variable "entity_id" {
  description = "SAML entity ID (issuer) for this Keycloak identity provider, sent in AuthnRequest messages."
  type        = string
}

variable "single_sign_on_service_url" {
  description = "URL of the SAML IdP's Single Sign-On (SSO) service endpoint."
  type        = string
}

# ── SAML-optional fields ──────────────────────────────────────────────────────

variable "single_logout_service_url" {
  description = "URL of the SAML IdP's Single Logout (SLO) service endpoint."
  type        = string
  default     = null
}

variable "backchannel_supported" {
  description = "When true, the SAML IdP supports backchannel logout."
  type        = bool
  default     = false
}

variable "name_id_policy_format" {
  description = "SAML NameID policy format URN (e.g. \"urn:oasis:names:tc:SAML:2.0:nameid-format:persistent\")."
  type        = string
  default     = null
}

variable "post_binding_response" {
  description = "When true, Keycloak expects the SAML response to be delivered via HTTP POST binding."
  type        = bool
  default     = false
}

variable "post_binding_authn_request" {
  description = "When true, Keycloak sends the AuthnRequest via HTTP POST binding instead of HTTP Redirect."
  type        = bool
  default     = false
}

variable "post_binding_logout" {
  description = "When true, Keycloak sends logout requests via HTTP POST binding."
  type        = bool
  default     = false
}

variable "want_assertions_signed" {
  description = "When true, Keycloak requires that SAML assertions be signed by the IdP."
  type        = bool
  default     = false
}

variable "want_assertions_encrypted" {
  description = "When true, Keycloak requires that SAML assertions be encrypted."
  type        = bool
  default     = false
}

variable "want_authn_requests_signed" {
  description = "When true, Keycloak signs outgoing AuthnRequest messages."
  type        = bool
  default     = false
}

variable "force_authn" {
  description = "When true, Keycloak requests that the IdP force re-authentication even if a valid session exists."
  type        = bool
  default     = false
}

variable "validate_signature" {
  description = "When true, Keycloak validates the signature on SAML responses and assertions using signing_certificate."
  type        = bool
  default     = false
}

variable "signing_certificate" {
  description = "PEM-encoded public certificate (without header/footer) used to validate signatures from the SAML IdP. Required when validate_signature = true."
  type        = string
  default     = null
}

variable "signature_algorithm" {
  description = "Signature algorithm used by the SAML IdP (e.g. \"RSA_SHA256\"). Leave null to use the Keycloak default."
  type        = string
  default     = null
}

variable "xml_sign_key_info_key_name_transformer" {
  description = "Strategy Keycloak uses to identify the signing key in the SAML KeyInfo element (e.g. \"KEY_ID\", \"CERT_SUBJECT\", \"NONE\")."
  type        = string
  default     = null
}

variable "principal_type" {
  description = "How Keycloak identifies the principal from the SAML assertion: SUBJECT, ATTRIBUTE, or FRIENDLY_ATTRIBUTE."
  type        = string
  default     = null
}

variable "principal_attribute" {
  description = "Name (or friendly name) of the SAML attribute to use as the principal when principal_type is ATTRIBUTE or FRIENDLY_ATTRIBUTE."
  type        = string
  default     = null
}

variable "authn_context_class_refs" {
  description = "List of SAML AuthnContext class reference URIs to request (e.g. [\"urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport\"])."
  type        = list(string)
  default     = []
}

variable "authn_context_decl_refs" {
  description = "List of SAML AuthnContext declaration reference URIs to request."
  type        = list(string)
  default     = []
}

variable "authn_context_comparison_type" {
  description = "Comparison method for AuthnContext: exact, minimum, maximum, or better."
  type        = string
  default     = null
}

variable "authenticate_by_default" {
  description = "When true, this provider is used by default for authentication."
  type        = bool
  default     = false
}

variable "provider_id" {
  description = "Internal Keycloak provider type identifier. Defaults to \"saml\"."
  type        = string
  default     = "saml"
}

# ── Mapper variables ──────────────────────────────────────────────────────────

variable "attribute_importer_mappers" {
  description = "Map of attribute-importer mappers, keyed by mapper name. Maps SAML attributes to Keycloak user attributes."
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
  description = "Map of attribute-to-role mappers, keyed by mapper name. Grants a Keycloak role when a specific SAML attribute value is present in the assertion."
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
  description = "Map of user-template-importer mappers, keyed by mapper name. Derives a Keycloak username from a template expression (e.g. \"${ALIAS}.${ATTRIBUTE.mail}\")."
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

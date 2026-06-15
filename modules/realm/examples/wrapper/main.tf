################################################################################
# Example: wrapper — manage many realms from one typed map
#
# Uses the ../../wrappers/realms fan-out module. Each entry falls back to the
# standalone module's secure defaults; only the fields that differ are set.
################################################################################

terraform {
  required_version = ">= 1.0"

  required_providers {
    keycloak = {
      source  = "keycloak/keycloak"
      version = ">= 5.7.0"
    }
  }
}

provider "keycloak" {
  # Configured via environment variables in CI, e.g.:
  #   KEYCLOAK_URL, KEYCLOAK_CLIENT_ID, KEYCLOAK_CLIENT_SECRET
  url = "https://auth.example.com"
}

module "realms" {
  source = "../../wrappers/realms"

  # Shared values applied to every item below unless overridden per entry.
  # Anything not set here still falls back to the standalone module's defaults.
  defaults = {
    ssl_required    = "all"
    login_theme     = "example"
    verify_email    = true
    password_policy = "upperCase(1) and lowerCase(1) and digits(1) and length(12) and notUsername"
  }

  items = {
    # Internal staff realm — locked down, relies on secure defaults + shared
    # `defaults` above. No self-registration.
    internal = {
      realm        = "internal"
      display_name = "Example Internal"

      create_events = true
      events = {
        admin_events_enabled         = true
        admin_events_details_enabled = true
      }
    }

    # Customer-facing realm — self-registration on, multi-locale.
    customers = {
      realm                = "customers"
      display_name         = "Example Customers"
      registration_allowed = true # overrides the standalone default

      internationalization = {
        supported_locales = ["en", "da", "de"]
        default_locale    = "en"
      }
    }
  }
}

output "realm_ids" {
  description = "Logical key => realm internal ID."
  value       = module.realms.realm_ids
}

output "realms" {
  description = "Full map of managed realms."
  value       = module.realms.realms
}

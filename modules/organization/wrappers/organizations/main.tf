################################################################################
# Keycloak organizations wrapper
# Provider: keycloak/keycloak >= 5.7.0
#
# Thin fan-out over the standalone ../../ organization module. Each argument
# resolves via try(each.value.X, var.defaults.X, <fallback>) so per-item values
# win over shared defaults, and the standalone module's own defaults apply last.
################################################################################

module "organization" {
  source   = "../../"
  for_each = var.items

  realm_id     = var.realm_id
  name         = each.value.name
  alias        = try(each.value.alias, var.defaults.alias, null)
  enabled      = try(each.value.enabled, var.defaults.enabled, null)
  description  = try(each.value.description, var.defaults.description, null)
  redirect_url = try(each.value.redirect_url, var.defaults.redirect_url, null)
  attributes   = try(each.value.attributes, var.defaults.attributes, {})
  domains      = try(each.value.domains, var.defaults.domains, {})
}

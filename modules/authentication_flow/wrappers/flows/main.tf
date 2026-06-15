################################################################################
# Keycloak authentication flows wrapper
# Provider: keycloak/keycloak >= 5.7.0
#
# Thin fan-out over the standalone ../../ authentication_flow module, following
# the terraform-aws-modules wrapper convention. Each argument resolves via
# try(each.value.X, var.defaults.X, <fallback>) so per-item values win over
# shared defaults, and the module's own defaults apply last.
################################################################################

module "flow" {
  source   = "../../"
  for_each = var.items

  realm_id    = var.realm_id
  alias       = each.value.alias
  description = try(each.value.description, var.defaults.description, null)
  provider_id = try(each.value.provider_id, var.defaults.provider_id, null)
  executions  = try(each.value.executions, var.defaults.executions, {})
  subflows    = try(each.value.subflows, var.defaults.subflows, {})
}

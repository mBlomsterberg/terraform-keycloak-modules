resource "keycloak_authentication_execution" "this" {
  for_each = var.create ? var.executions : {}

  realm_id          = var.realm_id
  parent_flow_alias = keycloak_authentication_flow.this[0].alias
  authenticator     = each.value.authenticator
  requirement       = each.value.requirement
  priority          = each.value.priority
}

resource "keycloak_authentication_execution_config" "this" {
  for_each = var.create ? {
    for k, v in var.executions : k => v.config if v.config != null
  } : {}

  realm_id     = var.realm_id
  execution_id = keycloak_authentication_execution.this[each.key].id
  alias        = each.value.alias
  config       = each.value.config
}

resource "keycloak_authentication_subflow" "this" {
  for_each = var.create ? var.subflows : {}

  realm_id          = var.realm_id
  parent_flow_alias = keycloak_authentication_flow.this[0].alias
  alias             = each.value.alias
  description       = each.value.description
  provider_id       = each.value.provider_id
  authenticator     = each.value.authenticator
  requirement       = each.value.requirement
  priority          = each.value.priority
}

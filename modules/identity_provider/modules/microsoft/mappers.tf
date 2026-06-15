resource "keycloak_attribute_importer_identity_provider_mapper" "this" {
  for_each = var.create ? var.attribute_importer_mappers : {}

  realm                   = var.realm_id
  name                    = each.key
  identity_provider_alias = local.idp_alias
  user_attribute          = each.value.user_attribute
  claim_name              = each.value.claim_name
  attribute_name          = each.value.attribute_name
  attribute_friendly_name = each.value.attribute_friendly_name
  extra_config            = each.value.extra_config
}

resource "keycloak_attribute_to_role_identity_provider_mapper" "this" {
  for_each = var.create ? var.attribute_to_role_mappers : {}

  realm                   = var.realm_id
  name                    = each.key
  identity_provider_alias = local.idp_alias
  role                    = each.value.role
  claim_name              = each.value.claim_name
  claim_value             = each.value.claim_value
  attribute_name          = each.value.attribute_name
  attribute_friendly_name = each.value.attribute_friendly_name
  attribute_value         = each.value.attribute_value
  extra_config            = each.value.extra_config
}

resource "keycloak_hardcoded_role_identity_provider_mapper" "this" {
  for_each = var.create ? var.hardcoded_role_mappers : {}

  realm                   = var.realm_id
  name                    = each.key
  identity_provider_alias = local.idp_alias
  role                    = each.value.role
  extra_config            = each.value.extra_config
}

resource "keycloak_hardcoded_attribute_identity_provider_mapper" "this" {
  for_each = var.create ? var.hardcoded_attribute_mappers : {}

  realm                   = var.realm_id
  name                    = each.key
  identity_provider_alias = local.idp_alias
  attribute_name          = each.value.attribute_name
  attribute_value         = each.value.attribute_value
  user_session            = each.value.user_session
  extra_config            = each.value.extra_config
}

resource "keycloak_hardcoded_group_identity_provider_mapper" "this" {
  for_each = var.create ? var.hardcoded_group_mappers : {}

  realm                   = var.realm_id
  name                    = each.key
  identity_provider_alias = local.idp_alias
  group                   = each.value.group
  extra_config            = each.value.extra_config
}

resource "keycloak_user_template_importer_identity_provider_mapper" "this" {
  for_each = var.create ? var.user_template_importer_mappers : {}

  realm                   = var.realm_id
  name                    = each.key
  identity_provider_alias = local.idp_alias
  template                = each.value.template
  extra_config            = each.value.extra_config
}

resource "keycloak_custom_identity_provider_mapper" "this" {
  for_each = var.create ? var.custom_mappers : {}

  realm                    = var.realm_id
  name                     = each.key
  identity_provider_alias  = local.idp_alias
  identity_provider_mapper = each.value.identity_provider_mapper
  extra_config             = each.value.extra_config
}

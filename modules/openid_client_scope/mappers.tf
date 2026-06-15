# ── User attribute mappers ─────────────────────────────────────────────────────
# Maps custom user attributes (keycloak_user.attributes) to token claims.

resource "keycloak_openid_user_attribute_protocol_mapper" "this" {
  for_each = var.create ? var.user_attribute_mappers : {}

  realm_id        = var.realm_id
  client_scope_id = local.scope_id
  name            = each.key

  user_attribute             = each.value.user_attribute
  claim_name                 = each.value.claim_name
  claim_value_type           = each.value.claim_value_type
  multivalued                = each.value.multivalued
  aggregate_attributes       = each.value.aggregate_attributes
  add_to_id_token            = each.value.add_to_id_token
  add_to_access_token        = each.value.add_to_access_token
  add_to_userinfo            = each.value.add_to_userinfo
  add_to_token_introspection = each.value.add_to_token_introspection
}

# ── User property mappers ──────────────────────────────────────────────────────
# Maps built-in user properties (username, email, firstName, lastName, etc.)

resource "keycloak_openid_user_property_protocol_mapper" "this" {
  for_each = var.create ? var.user_property_mappers : {}

  realm_id        = var.realm_id
  client_scope_id = local.scope_id
  name            = each.key

  user_property       = each.value.user_property
  claim_name          = each.value.claim_name
  claim_value_type    = each.value.claim_value_type
  add_to_id_token     = each.value.add_to_id_token
  add_to_access_token = each.value.add_to_access_token
  add_to_userinfo     = each.value.add_to_userinfo
}

# ── Group membership mappers ───────────────────────────────────────────────────
# Adds the user's group memberships (names or full paths) as a token claim.

resource "keycloak_openid_group_membership_protocol_mapper" "this" {
  for_each = var.create ? var.group_membership_mappers : {}

  realm_id        = var.realm_id
  client_scope_id = local.scope_id
  name            = each.key

  claim_name          = each.value.claim_name
  full_path           = each.value.full_path
  add_to_id_token     = each.value.add_to_id_token
  add_to_access_token = each.value.add_to_access_token
  add_to_userinfo     = each.value.add_to_userinfo
}

# ── User realm role mappers ────────────────────────────────────────────────────
# Adds the user's realm-level role assignments as a token claim.

resource "keycloak_openid_user_realm_role_protocol_mapper" "this" {
  for_each = var.create ? var.user_realm_role_mappers : {}

  realm_id        = var.realm_id
  client_scope_id = local.scope_id
  name            = each.key

  claim_name                 = each.value.claim_name
  claim_value_type           = each.value.claim_value_type
  multivalued                = each.value.multivalued
  realm_role_prefix          = each.value.realm_role_prefix
  add_to_id_token            = each.value.add_to_id_token
  add_to_access_token        = each.value.add_to_access_token
  add_to_userinfo            = each.value.add_to_userinfo
  add_to_token_introspection = each.value.add_to_token_introspection
}

# ── User client role mappers ───────────────────────────────────────────────────
# Adds the user's role assignments for a specific client as a token claim.

resource "keycloak_openid_user_client_role_protocol_mapper" "this" {
  for_each = var.create ? var.user_client_role_mappers : {}

  realm_id        = var.realm_id
  client_scope_id = local.scope_id
  name            = each.key

  claim_name                  = each.value.claim_name
  claim_value_type            = each.value.claim_value_type
  multivalued                 = each.value.multivalued
  client_id_for_role_mappings = each.value.client_id_for_role_mappings
  client_role_prefix          = each.value.client_role_prefix
  add_to_id_token             = each.value.add_to_id_token
  add_to_access_token         = each.value.add_to_access_token
  add_to_userinfo             = each.value.add_to_userinfo
}

# ── Audience mappers ───────────────────────────────────────────────────────────
# Adds an audience entry to the token's aud claim.

resource "keycloak_openid_audience_protocol_mapper" "this" {
  for_each = var.create ? var.audience_mappers : {}

  realm_id        = var.realm_id
  client_scope_id = local.scope_id
  name            = each.key

  included_client_audience = each.value.included_client_audience
  included_custom_audience = each.value.included_custom_audience
  add_to_id_token          = each.value.add_to_id_token
  add_to_access_token      = each.value.add_to_access_token
}

# ── Hardcoded claim mappers ────────────────────────────────────────────────────
# Inserts a fixed claim value into every token for this scope.

resource "keycloak_openid_hardcoded_claim_protocol_mapper" "this" {
  for_each = var.create ? var.hardcoded_claim_mappers : {}

  realm_id        = var.realm_id
  client_scope_id = local.scope_id
  name            = each.key

  claim_name          = each.value.claim_name
  claim_value         = each.value.claim_value
  claim_value_type    = each.value.claim_value_type
  add_to_id_token     = each.value.add_to_id_token
  add_to_access_token = each.value.add_to_access_token
  add_to_userinfo     = each.value.add_to_userinfo
}

# ── Full name mappers ──────────────────────────────────────────────────────────
# Adds the user's full name (firstName + lastName) as the "name" claim.

resource "keycloak_openid_full_name_protocol_mapper" "this" {
  for_each = var.create ? var.full_name_mappers : {}

  realm_id        = var.realm_id
  client_scope_id = local.scope_id
  name            = each.key

  add_to_id_token     = each.value.add_to_id_token
  add_to_access_token = each.value.add_to_access_token
  add_to_userinfo     = each.value.add_to_userinfo
}

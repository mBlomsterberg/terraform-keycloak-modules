resource "keycloak_user" "this" {
  count = var.create ? 1 : 0

  realm_id         = var.realm_id
  username         = var.username
  enabled          = var.enabled
  email            = var.email
  email_verified   = var.email_verified
  first_name       = var.first_name
  last_name        = var.last_name
  attributes       = var.attributes
  required_actions = var.required_actions
  import           = var.import_existing

  dynamic "initial_password" {
    for_each = var.initial_password != null ? [var.initial_password] : []
    content {
      value     = initial_password.value.value
      temporary = initial_password.value.temporary
    }
  }

  dynamic "federated_identity" {
    for_each = var.federated_identities
    content {
      identity_provider = federated_identity.key
      user_id           = federated_identity.value.user_id
      user_name         = federated_identity.value.user_name
    }
  }
}

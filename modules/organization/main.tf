resource "keycloak_organization" "this" {
  count = var.create ? 1 : 0

  realm        = var.realm_id
  name         = var.name
  alias        = var.alias
  enabled      = var.enabled
  description  = var.description
  redirect_url = var.redirect_url
  attributes   = var.attributes

  dynamic "domain" {
    for_each = var.domains
    content {
      name     = domain.key
      verified = domain.value.verified
    }
  }
}

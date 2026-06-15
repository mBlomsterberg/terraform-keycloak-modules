output "acme_id" {
  description = "Internal Keycloak UUID of the ACME organization."
  value       = module.acme.id
}

output "acme_alias" {
  description = "Alias of the ACME organization."
  value       = module.acme.alias
}

output "globex_id" {
  description = "Internal Keycloak UUID of the Globex organization."
  value       = module.globex.id
}

output "globex_alias" {
  description = "Alias of the Globex organization."
  value       = module.globex.alias
}

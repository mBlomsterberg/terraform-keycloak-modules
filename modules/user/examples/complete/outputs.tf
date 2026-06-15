output "ci_bot_id" {
  description = "Internal Keycloak UUID of the CI bot user."
  value       = module.ci_bot.id
}

output "ci_bot_username" {
  description = "Username of the CI bot."
  value       = module.ci_bot.username
}

output "alice_id" {
  description = "Internal Keycloak UUID of Alice's user account."
  value       = module.alice.id
}

output "legacy_admin_id" {
  description = "Internal Keycloak UUID of the imported legacy admin user."
  value       = module.legacy_admin.id
}

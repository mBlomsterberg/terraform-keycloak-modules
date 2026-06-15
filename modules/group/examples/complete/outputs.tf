output "engineering_id" {
  description = "Internal UUID of the engineering root group."
  value       = module.engineering.id
}

output "engineering_path" {
  description = "Full path of the engineering group."
  value       = module.engineering.path
}

output "backend_id" {
  description = "Internal UUID of the backend child group."
  value       = module.backend.id
}

output "backend_path" {
  description = "Full path of the backend group (e.g. /engineering/backend)."
  value       = module.backend.path
}

output "frontend_id" {
  description = "Internal UUID of the frontend child group."
  value       = module.frontend.id
}

output "ops_id" {
  description = "Internal UUID of the ops group."
  value       = module.ops.id
}

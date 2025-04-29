output "resource" {
  value       = module.aihub.resource 
  description = "The Azure ai_foundry resource"
  sensitive = true  
}

output "global_settings" {
  value       = local.global_settings
  description = "The framework global_settings"
}


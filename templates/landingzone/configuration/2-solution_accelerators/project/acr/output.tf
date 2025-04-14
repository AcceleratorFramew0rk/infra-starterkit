output "resource" {
  value       = module.container_registry.resource 
  description = "The Azure Acr resource"
  sensitive = true  
}

output "global_settings" {
  value       = local.global_settings
  description = "The framework global_settings"
}


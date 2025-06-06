output "resource" {
  value       = module.aiservices.resource 
  description = "The Azure ai services resource"
  sensitive = true  
}

output "global_settings" {
  value       = local.global_settings
  description = "The framework global_settings"
}


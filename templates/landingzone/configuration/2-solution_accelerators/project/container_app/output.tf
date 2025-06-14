
output "resource" {
  value       = module.containerapp
  description = "The framework global_settings"
  sensitive = true  
}

output "global_settings" {
  value       = local.global_settings
  description = "The framework global_settings"
}

# output "private_dns_zones_resource" {
#   value       = module.private_dns_zones[0].resource 
#   description = "The Azure private_dns_zones resource"
#   sensitive = true  
# }


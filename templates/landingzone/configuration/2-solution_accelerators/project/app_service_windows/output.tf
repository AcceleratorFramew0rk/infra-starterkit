output "resource" {
  value       = module.appservice
  description = "The Azure appservice resource"
  sensitive = true  
}

output "private_dns_zones_resource" {
  value       = module.appservice.private_dns_zones_resource 
  description = "The Azure private_dns_zones resource"
  sensitive = true  
}


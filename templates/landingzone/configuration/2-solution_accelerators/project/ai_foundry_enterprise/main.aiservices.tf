module "private_dns_cognitiveservices" {
  source              = "Azure/avm-res-network-privatednszone/azurerm"
  version             = "~> 0.2"
  domain_name         = "privatelink.cognitiveservices.azure.com"
  resource_group_name   = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  virtual_network_links = {
    dnslink = {
      vnetlinkname = "privatelink.cognitiveservices.azure.com"
      vnetid           = try(local.remote.networking.virtual_networks.spoke_project.virtual_network.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_network.id : var.vnet_id  
    }
  }
  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "cognitiveservices service private dns zone" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "app"   
    }
  ) 
  enable_telemetry = var.enable_telemetry
}

module "private_dns_openai" {
  source              = "Azure/avm-res-network-privatednszone/azurerm"
  version             = "~> 0.2"
  domain_name         = "privatelink.openai.azure.com"
  resource_group_name   = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  virtual_network_links = {
    dnslink = {
      vnetlinkname = "privatelink.openai.azure.com"
      vnetid           = try(local.remote.networking.virtual_networks.spoke_project.virtual_network.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_network.id : var.vnet_id  
    }
  }
  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "openai service private dns zone" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "app"   
    }
  ) 
  enable_telemetry = var.enable_telemetry
}

module "private_dns_services_ai" {
  source              = "Azure/avm-res-network-privatednszone/azurerm"
  version             = "~> 0.2"
  domain_name         = "privatelink.services.ai.azure.com"
  resource_group_name   = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  virtual_network_links = {
    dnslink = {
      vnetlinkname = "privatelink.services.ai.azure.com"
      vnetid           = try(local.remote.networking.virtual_networks.spoke_project.virtual_network.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_network.id : var.vnet_id  
    }
  }
  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "ai service private dns zone" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "app"   
    }
  ) 
  enable_telemetry = var.enable_telemetry
}

module "aiservices" {
  source                             = "Azure/avm-res-cognitiveservices-account/azurerm"
  version                            = "0.6.0"
  resource_group_name   = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  kind                               = "AIServices"
  name                               = replace("${module.naming.cognitive_account.name_unique}${random_string.this.result}", "-", "") 
  location                           = var.ai_services_location # eastus 
  enable_telemetry                   = var.enable_telemetry
  sku_name                           = var.sku # "S0"
  public_network_access_enabled      = false # true # required for AI Foundry
  local_auth_enabled                 = true
  outbound_network_access_restricted = false
  custom_subdomain_name = "aiservices-${local.base_name}-${random_string.this.result}" # ramdom

  # identity
  managed_identities = {
    system_assigned = true
  }   

  private_endpoints = {
    primary = {
      subnet_resource_id            = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.subnet_name].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.subnet_name].resource.id : var.subnet_id 

      private_dns_zone_resource_ids = [module.private_dns_cognitiveservices.resource_id,
                                       module.private_dns_openai.resource_id,
                                       module.private_dns_services_ai.resource_id]
      tags                          = local.tags
    }
  }

  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "ai services" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "app"   
    }
  ) 

  depends_on = [
    module.private_dns_cognitiveservices,
    module.private_dns_openai,
    module.private_dns_services_ai
  ]
}

# TODO: 
# 1. Add private endpoint for AI Services from ServiceSubnet (or PrivateEndpointSubnet)

# resource "azurerm_private_endpoint" "ai_services_private_endpoint" {
#   name                = local.private_endpoint_name
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   subnet_id           = var.private_endpoint_subnet_id

#   private_service_connection {
#     name                           = "connection-${var.base_name}"
#     private_connection_resource_id = azapi_resource.ai_services.id
#     subresource_names              = ["account"]
#     is_manual_connection           = false
#   }

#   private_dns_zone_group {
#     name = "ai-services-dns-group"

#     private_dns_zone_ids = concat(
#       var.aiservice.private_dns_zone_ids,
#       var.aiservice.deploy_private_dns_zones ? [
#         azurerm_private_dns_zone.cognitive_services[0].id,
#         azurerm_private_dns_zone.openai[0].id,
#         azurerm_private_dns_zone.services_ai[0].id
#       ] : []
#     )
#   }
#   tags = { "environment" = "production" }
# }


# resource "azurerm_private_dns_zone" "cognitive_services" {
#   count               = var.aiservice.deploy_private_dns_zones ? 1 : 0
#   name                = "privatelink.cognitiveservices.azure.com"
#   resource_group_name = var.resource_group_name
# }

# resource "azurerm_private_dns_zone" "openai" {
#   count               = var.aiservice.deploy_private_dns_zones ? 1 : 0
#   name                = "privatelink.openai.azure.com"
#   resource_group_name = var.resource_group_name
# }

# resource "azurerm_private_dns_zone" "services_ai" {
#   count               = var.aiservice.deploy_private_dns_zones ? 1 : 0
#   name                = "privatelink.services.ai.azure.com"
#   resource_group_name = var.resource_group_name
# }
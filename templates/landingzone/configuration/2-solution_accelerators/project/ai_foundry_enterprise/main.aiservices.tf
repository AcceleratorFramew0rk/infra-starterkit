
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
}



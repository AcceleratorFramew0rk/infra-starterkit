
# TODO: 
# 1. diagnostic settings for all resources
# 2. Approval for managed private endpoint - 2 for AI Foundry, 2 for AI Search Services
module "aifoundry" {
  # source = "./../../../../../../modules/terraform-azurerm-aaf/modules/aoai/azure-ai-foundry" 
  source = "AcceleratorFramew0rk/aaf/azurerm//modules/aoai/azure-ai-foundry" 

  name                         = "${module.naming.cognitive_account.name}-${random_string.this.result}" # alpha numeric characters only are allowed in "name var.name_prefix == null ? "${random_string.prefix.result}${var.acr_name}" : "${var.name_prefix}${var.acr_name}"
  base_name                    = "${module.naming.cognitive_account.name}" # alpha numeric characters only are allowed in "name var.name_prefix == null ? "${random_string.prefix.result}${var.acr_name}" : "${var.name_prefix}${var.acr_name}"

  location                     = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  resource_group_name          = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  resource_group_id            = try(local.global_settings.resource_group_id, null) == null ? azurerm_resource_group.this.0.id : local.global_settings.resource_group_id

  ai_services_location                     = azurerm_resource_group.eastus.location
  ai_services_resource_group_name           = azurerm_resource_group.eastus.name

  log_analytics_workspace_id = try(local.remote.log_analytics_workspace.id, null) != null ? local.remote.log_analytics_workspace.id : var.log_analytics_workspace_id
  vnet_id                    = try(local.remote.networking.virtual_networks.spoke_project.virtual_network.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_network.id : var.vnet_id  
  subnet_id                  = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.subnet_name].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.subnet_name].resource.id : var.subnet_id 
  private_endpoint_subnet_id = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.private_endpoint_subnet_name].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.private_endpoint_subnet_name].resource.id : var.private_endpoint_subnet_id 


  diagnostic_settings = {
    all_diag_setting_1 = {
      name                           = "${module.naming.monitor_diagnostic_setting.name_unique}-aihub"
      log_groups                     = ["allLogs"]
      metric_categories              = ["AllMetrics"]
      log_analytics_destination_type = "Dedicated"
      workspace_resource_id          = try(local.remote.log_analytics_workspace.id, null) != null ? local.remote.log_analytics_workspace.id : var.log_analytics_workspace_id # azurerm_log_analytics_workspace.this_workspace.id
    }
  }

  tags                = merge(
    local.global_settings.tags,
    {
      purpose = "ai foundry services" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "app"   
    }
  ) 
    
}

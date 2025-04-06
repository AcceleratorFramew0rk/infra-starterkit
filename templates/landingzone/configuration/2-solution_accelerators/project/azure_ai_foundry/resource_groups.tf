resource "azurerm_resource_group" "this" {
  count = try(local.global_settings.resource_group_name, null) == null ? 1 : 0
  
  name     = "${module.naming.resource_group.name}-solution-accelerators-azureaifoundry" 
  location = "${try(local.global_settings.location, var.location)}" 
}

resource "azurerm_resource_group" "eastus" {
  # count = try(local.global_settings.resource_group_name, null) == null ? 1 : 0

  name     = "${module.naming.resource_group.name}-solution-accelerators-azureaifoundry-eastus" 
  location = "eastus" # hardcoded to eastus for ai-services which is not available in southeastasia
}


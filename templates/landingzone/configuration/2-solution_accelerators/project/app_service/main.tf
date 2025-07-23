resource "azurerm_app_service_plan" "this" {
  name                         = "${module.naming.app_service_plan.name}-${random_string.this.result}" # module.naming.app_service_plan.name
  location                     = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  resource_group_name          = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  kind                         = var.kind # "Linux" or "Windows"
  maximum_elastic_worker_count = 5 

  # For kind=Linux must be set to true and for kind=Windows must be set to false
  reserved         = try(var.kind, "Linux") == "Linux" ? true : false 

  sku {
    tier     = var.tier # "Standard"
    size     = var.size # "S1"
  }

  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "app service plan" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "app"   
    }
  )   
}

module "private_dns_zones" {
  source                = "Azure/avm-res-network-privatednszone/azurerm"   
  # version = "0.1.2" 
  version = "0.3.3"
  
  count = var.private_dns_zones_enabled ? 1 : 0

  enable_telemetry      = true
  resource_group_name   = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  domain_name           = "privatelink.azurewebsites.net"
  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "app service private dns zone" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "app"   
    }
  ) 
  virtual_network_links = {
      vnetlink1 = {
        vnetlinkname     = "vnetlink1"
        vnetid           = try(local.remote.networking.virtual_networks.spoke_project.virtual_network.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_network.id : var.vnet_id  
        autoregistration = false # true
        tags = {
          "env" = "dev"
        }
      }
    }
}


module "appservice" {
  source  = "Azure/avm-res-web-site/azurerm"
  version = "0.17.0"
  # insert the 6 required variables here

  for_each                     = toset(var.resource_names)

  kind     = "webapp"
  name                         = "${module.naming.app_service.name}-${each.value}-ez-${random_string.this.result}" # alpha numeric characters only are allowed in "name var.name_prefix == null ? "${random_string.prefix.result}${var.acr_name}" : "${var.name_prefix}${var.acr_name}"
  resource_group_name          = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  location                     = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  os_type                  = var.kind 
  service_plan_resource_id = azurerm_app_service_plan.this.id

  site_config = {
    # Free tier only supports 32-bit
    use_32_bit_worker_process = true
    # Run "az webapp list-runtimes --linux" for current supported values, but
    # always connect to the runtime with "az webapp ssh" or output the value
    # of process.version from a running app because you might not get the
    # version you expect
    linux_fx_version = try(var.kind, "Linux") == "Linux" ? var.linux_fx_version : null # try(var.linux_fx_version, null) # "NODE:20-lts" # "NODE|12-lts"
    dotnet_framework_version = var.dotnet_framework_version # "v2.0" # "v4.0" # "v5.0" # "v6.0"
  }

  app_settings = {
    # "WEBSITE_NODE_DEFAULT_VERSION" = "6.9.1"
    "Example" = "Extend",
    "LZ"      = "CAF"
  }

  application_insights = {
    workspace_resource_id = try(local.remote.log_analytics_workspace.id, null) != null ? local.remote.log_analytics_workspace.id : var.log_analytics_workspace_id
  }

  private_endpoints = {
    primary = {
      private_dns_zone_resource_ids = [module.private_dns_zones.0.resource_id] 
      subnet_resource_id            = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.ingress_subnet_name].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.ingress_subnet_name].resource.id : var.subnet_id 
    }
  }

  enable_telemetry = var.enable_telemetry

  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "app service" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "app"   
    }
  ) 
}

module "appserviceintranet" {
  source  = "Azure/avm-res-web-site/azurerm"
  version = "0.17.0"
  # insert the 6 required variables here

  for_each                     = toset(try(var.intranet_resource_names, []))
  # for_each = length(try(var.intranet_resource_names, {})) > 0 ? toset(var.intranet_resource_names) : {}
  # for_each                     = try(var.intranet_appservice_enabled, false) ? toset(var.intranet_resource_names) : {} 

  kind     = "webapp"
  name                         = "${module.naming.app_service.name}-${each.value}-iz-${random_string.this.result}" # alpha numeric characters only are allowed in "name var.name_prefix == null ? "${random_string.prefix.result}${var.acr_name}" : "${var.name_prefix}${var.acr_name}"
  resource_group_name          = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  location                     = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  os_type                  = var.kind 
  service_plan_resource_id = azurerm_app_service_plan.this.id

  site_config = {
    # Free tier only supports 32-bit
    use_32_bit_worker_process = true
    # Run "az webapp list-runtimes --linux" for current supported values, but
    # always connect to the runtime with "az webapp ssh" or output the value
    # of process.version from a running app because you might not get the
    # version you expect
    linux_fx_version = try(var.kind, "Linux") == "Linux" ? var.linux_fx_version : null # try(var.linux_fx_version, null) # "NODE:20-lts" # "NODE|12-lts"
    dotnet_framework_version = var.dotnet_framework_version # "v2.0" # "v4.0" # "v5.0" # "v6.0"
  }

  app_settings = {
    # "WEBSITE_NODE_DEFAULT_VERSION" = "6.9.1"
    "Example" = "Extend",
    "LZ"      = "CAF"
  }

  application_insights = {
    workspace_resource_id = try(local.remote.log_analytics_workspace.id, null) != null ? local.remote.log_analytics_workspace.id : var.log_analytics_workspace_id
  }

  private_endpoints = {
    primary = {
      private_dns_zone_resource_ids = [module.private_dns_zones.0.resource_id] 
      subnet_resource_id            = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.ingress_intranet_subnet_name].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.ingress_intranet_subnet_name].resource.id : var.subnet_id 
    }
  }

  enable_telemetry = var.enable_telemetry

  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "app service" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "app"   
    }
  ) 
}

# Tested with :  AzureRM version 2.55.0
# Ref : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/
resource "azurerm_app_service_virtual_network_swift_connection" "vnet_config" {
  
  for_each = module.appservice

  app_service_id = each.value.resource.id 
  subnet_id      = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.subnet_name].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.subnet_name].resource.id : var.subnet_id 

  depends_on = [module.private_dns_zones, module.appservice]
}

# # Tested with :  AzureRM version 2.55.0
# # Ref : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/
# resource "azurerm_app_service_virtual_network_swift_connection" "vnet_config_intranet" {
  
#   for_each = try(module.appserviceintranet, {})

#   app_service_id = each.value.resource.id 
#   subnet_id      = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.intranet_subnet_name].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.intranet_subnet_name].resource.id : var.intranet_subnet_id 

#   depends_on = [module.private_dns_zones, module.appservice]
# }


# Tested with :  AzureRM version 2.55.0
# Ref : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/
resource "azurerm_app_service_virtual_network_swift_connection" "vnet_config_intranet" {
  for_each = length(try(module.appserviceintranet.resource, {})) > 0 ? module.appserviceintranet : {}
  # for_each                     = try(var.intranet_appservice_enabled, false) == true ? module.appserviceintranet : {} 

  app_service_id = each.value.resource.id

  subnet_id      = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.intranet_subnet_name].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.intranet_subnet_name].resource.id : var.intranet_subnet_id 


  depends_on = [module.private_dns_zones, module.appservice]
}
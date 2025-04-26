module "private_dns_aml_api" {
  source              = "Azure/avm-res-network-privatednszone/azurerm"
  version             = "~> 0.2"
  domain_name         = "privatelink.api.azureml.ms"
  resource_group_name   = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  virtual_network_links = {
    dnslink = {
      vnetlinkname = "privatelink.api.azureml.ms"
      vnetid           = try(local.remote.networking.virtual_networks.spoke_project.virtual_network.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_network.id : var.vnet_id  
    }
  }
  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "aml api private dns zone" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "app"   
    }
  ) 
  enable_telemetry = var.enable_telemetry
}

module "private_dns_aml_notebooks" {
  source              = "Azure/avm-res-network-privatednszone/azurerm"
  version             = "~> 0.2"
  domain_name         = "privatelink.notebooks.azure.net"
  resource_group_name   = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name  
  virtual_network_links = {
    dnslink = {
      vnetlinkname = "privatelink.notebooks.azureml.ms"
      vnetid           = try(local.remote.networking.virtual_networks.spoke_project.virtual_network.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_network.id : var.vnet_id  
    }
  }
  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "aml notebooks private dns zone" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "app"   
    }
  ) 
  enable_telemetry = var.enable_telemetry
}

module "private_dns_keyvault_vault" {
  source              = "Azure/avm-res-network-privatednszone/azurerm"
  version             = "~> 0.2"
  domain_name         = "privatelink.vaultcore.azure.net"
  resource_group_name   = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name  
  virtual_network_links = {
    dnslink = {
      vnetlinkname = "privatelink.notebooks.azureml.ms"
      vnetid           = try(local.remote.networking.virtual_networks.spoke_project.virtual_network.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_network.id : var.vnet_id  
    }
  }
  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "keyvault private dns zone" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "app"   
    }
  ) 
  enable_telemetry = var.enable_telemetry
}

module "private_dns_storageaccount_blob" {
  source              = "Azure/avm-res-network-privatednszone/azurerm"
  version             = "~> 0.2"
  domain_name         = "privatelink.blob.core.windows.net"
  resource_group_name   = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name  
  virtual_network_links = {
    dnslink = {
      vnetlinkname = "privatelink.blob.core.windows.net"
      vnetid           = try(local.remote.networking.virtual_networks.spoke_project.virtual_network.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_network.id : var.vnet_id  
    }
  }
  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "storage account blob private dns zone" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "app"   
    }
  ) 
  enable_telemetry = var.enable_telemetry
}

module "private_dns_storageaccount_file" {
  source              = "Azure/avm-res-network-privatednszone/azurerm"
  version             = "~> 0.2"
  domain_name         = "privatelink.file.core.windows.net"
  resource_group_name   = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name  
  virtual_network_links = {
    dnslink = {
      vnetlinkname = "privatelink.file.core.windows.net"
      vnetid           = try(local.remote.networking.virtual_networks.spoke_project.virtual_network.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_network.id : var.vnet_id  
    }
  }
  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "storage account file private dns zone" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "app"   
    }
  ) 
  enable_telemetry = var.enable_telemetry
}

module "private_dns_containerregistry_registry" {
  source              = "Azure/avm-res-network-privatednszone/azurerm"
  version             = "~> 0.2"
  domain_name         = "privatelink.azurecr.io"
  resource_group_name   = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name  
  virtual_network_links = {
    dnslink = {
      vnetlinkname = "privatelink.azurecr.io"
      vnetid           = try(local.remote.networking.virtual_networks.spoke_project.virtual_network.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_network.id : var.vnet_id  
    }
  }
  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "container registry private dns zone" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "app"   
    }
  ) 
  enable_telemetry = var.enable_telemetry
}

module "avm_res_containerregistry_registry" {
  source = "Azure/avm-res-containerregistry-registry/azurerm"

  version = "~> 0.4"

  name                          = replace("${module.naming.container_registry.name}${random_string.this.result}", "-", "")
  location                      = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  resource_group_name   = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name  
  public_network_access_enabled = false
  zone_redundancy_enabled       = false

  private_endpoints = {
    registry = {
      name                          = "pe-containerregistry-regsitry"
      subnet_resource_id                      = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.subnet_name].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.subnet_name].resource.id : var.subnet_id 

      private_dns_zone_resource_ids = [module.private_dns_containerregistry_registry.resource_id]
      inherit_lock                  = false
    }
  }

  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "container registry" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "app"   
    }
  ) 
}

module "avm_res_keyvault_vault" {
  source  = "Azure/avm-res-keyvault-vault/azurerm"
  version = "~> 0.9"

  tenant_id           = data.azurerm_client_config.current.tenant_id
  enable_telemetry    = var.enable_telemetry
  name                = "${module.naming.key_vault.name}${random_string.this.result}" 
  resource_group_name   = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  location                      = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location

  network_acls = {
    bypass         = "AzureServices"
    default_action = "Deny"
  }

  public_network_access_enabled = false

  private_endpoints = {
    vault = {
      name                          = "pe-keyvault-vault"
      subnet_resource_id                      = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.subnet_name].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.subnet_name].resource.id : var.subnet_id 

      private_dns_zone_resource_ids = [module.private_dns_keyvault_vault.resource_id]
      inherit_lock                  = false
    }
  }

  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "key vault" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "app"   
    }
  ) 
}

module "avm_res_storage_storageaccount" {
  source  = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "~> 0.4"

  enable_telemetry              = var.enable_telemetry
  name                          = replace("${module.naming.storage_account.name}${random_string.this.result}", "-", "") 
  resource_group_name   = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  location                      = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  shared_access_key_enabled     = true
  public_network_access_enabled = false

  managed_identities = {
    system_assigned = true
  }

  private_endpoints = {
    blob = {
      name                          = "pe-storage-blob"
      subnet_resource_id                      = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.subnet_name].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.subnet_name].resource.id : var.subnet_id 

      subresource_name              = "blob"
      private_dns_zone_resource_ids = [module.private_dns_storageaccount_blob.resource_id]
      inherit_lock                  = false
    }
    file = {
      name                          = "pe-storage-file"
      subnet_resource_id                      = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.subnet_name].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.subnet_name].resource.id : var.subnet_id 

      subresource_name              = "file"
      private_dns_zone_resource_ids = [module.private_dns_storageaccount_file.resource_id]
      inherit_lock                  = false
    }
  }

  network_rules = {
    bypass         = ["Logging", "Metrics", "AzureServices"]
    default_action = "Deny"
  }

  # for idempotency
  blob_properties = {
    cors_rule = [{
      allowed_headers = ["*", ]
      allowed_methods = [
        "GET",
        "HEAD",
        "PUT",
        "DELETE",
        "OPTIONS",
        "POST",
        "PATCH",
      ]
      allowed_origins = [
        "https://mlworkspace.azure.ai",
        "https://ml.azure.com",
        "https://*.ml.azure.com",
        "https://ai.azure.com",
        "https://*.ai.azure.com",
      ]
      exposed_headers = [
        "*",
      ]
      max_age_in_seconds = 1800
    }]
  }

  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "storage account" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "app"   
    }
  ) 
}

resource "azurerm_application_insights" "this" {
  name                     = "${local.base_name}-appinsight"
  location                      = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  resource_group_name   = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name

  workspace_id = try(local.remote.log_analytics_workspace.id, null) != null ? local.remote.log_analytics_workspace.id : var.log_analytics_workspace_id

  application_type    = "web"

  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "application insights" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "app"   
    }
  ) 
}

module "diagnosticsetting_appinsight" {
  source = "AcceleratorFramew0rk/aaf/azurerm//modules/diagnostics/terraform-azurerm-diagnosticsetting"  

  name                = "${module.naming.monitor_diagnostic_setting.name}-appinsight-${random_string.this.result}"
  target_resource_id = azurerm_application_insights.this.id
  log_analytics_workspace_id = try(local.remote.log_analytics_workspace.id, null) != null ? local.remote.log_analytics_workspace.id : var.log_analytics_workspace_id
  diagnostics = {
    categories = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AppAvailabilityResults", true, false, 7],   
        ["AppBrowserTimings", true, false, 7],   
        ["AppEvents", true, false, 7],  
        ["AppMetrics", true, false, 7],  
        ["AppDependencies", true, false, 7],  
        ["AppExceptions", true, false, 7],  
        ["AppPageViews", true, false, 7],  
        ["AppPerformanceCounters", true, false, 7],  
        ["AppRequests", true, false, 7],  
        ["AppSystemEvents", true, false, 7],  
        ["AppTraces", true, false, 7],                                         
      ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
        ["AllMetrics", true, false, 7],
      ]
    }
  }
}

# This is the module call
# Do not specify location here due to the randomization above.
# Leaving location as `null` will cause the module to use the resource group location
# with a data source.
# private endpoint to storage account, keyvault, acr
# outbound private link to ai service, search service
module "aihub" {
  source  = "Azure/avm-res-machinelearningservices-workspace/azurerm"
  version = "0.4.1"

  location                      = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  name                    = local.name
  resource_group_name   = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  is_private              = true
  kind                    = "Hub"
  workspace_friendly_name = "Private AI Studio Hub"

  storage_account = {
    resource_id = module.avm_res_storage_storageaccount.resource_id
    create_new = false
  }

  key_vault = {
    resource_id = module.avm_res_keyvault_vault.resource_id
    create_new = false
  }

  container_registry = {
    resource_id = module.avm_res_containerregistry_registry.resource_id
    create_new = false
  }

  # # aihub outbound service connection - TODO: not working - use resource "azapi_update_resource" "ai_hub_update"
  # aiservices = {
  #   # resource_group_id         = azurerm_resource_group.this.id
  #   resource_group_id   = azurerm_resource_group.eastus.id # try(local.global_settings.resource_group_id, null) == null ? azurerm_resource_group.this.0.id : local.global_settings.resource_group_id
  #   name                      = module.aiservices.name
  #   create_service_connection = true
  # }

  # configure ai hub outbound rules to search services 
  workspace_managed_network = {
    isolation_mode = "AllowOnlyApprovedOutbound"
    outbound_rules = {
      private_endpoint = {
        aisearch = {
          resource_id         = module.aisearch.resource_id
          sub_resource_target = "searchService"
        }
      }
    }
  }

  application_insights = {
    resource_id          = azurerm_application_insights.this.id
    create_new = false
  }

  private_endpoints = {
    hub = {
      name                          = "${local.base_name}-pep"
      subnet_resource_id                      = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.subnet_name].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.subnet_name].resource.id : var.subnet_id 
      private_dns_zone_resource_ids = [module.private_dns_aml_api.resource_id, module.private_dns_aml_notebooks.resource_id]
      inherit_lock                  = false
    }
  }

  diagnostic_settings = {
    diag = {
      name                  = "aml${module.naming.monitor_diagnostic_setting.name_unique}-aihub"
      workspace_resource_id = try(local.remote.log_analytics_workspace.id, null) != null ? local.remote.log_analytics_workspace.id : var.log_analytics_workspace_id
    }
  }

  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "ai foundry hub" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "app"   
    }
  ) 
  enable_telemetry = var.enable_telemetry
}

module "aihub_project" {
  source  = "Azure/avm-res-machinelearningservices-workspace/azurerm"
  version = "0.4.1"

  location                      = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location
  name                    = local.base_name
  resource_group_name   = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name
  kind                    = "Project"
  workspace_description = "aihub project 1"
  workspace_friendly_name = "${local.base_name} AI Project"
  ai_studio_hub_id = module.aihub.resource.id
  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "ai hub project" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "app"   
    }
  ) 
}

# # configure ai hub outbound rules to search services and ai services
resource "azapi_update_resource" "ai_hub_update" {
  type       = "Microsoft.MachineLearningServices/workspaces@2024-07-01-preview"
  resource_id = module.aihub.resource.id # azurerm_ai_foundry.this.id
  
  body = {
    properties = {
      managedNetwork = {
        outboundRules = local.base_ai_hub_outbound_rules 
      }
    }
  }

  depends_on = [
    module.aihub,
    module.aisearch,
    module.aiservices,
  ]
}





















# resource "random_id" "short_name" {
#   byte_length = 4
# }

# module "ai_foundry_enterprise" {
#   # source = "./../../../../../../modules/terraform-azurerm-aaf/modules/aoai/terraform-azurerm-avm-ptn-ai-foundry-enterprise"
#   source = "AcceleratorFramew0rk/aaf/azurerm//modules/aoai/terraform-azurerm-avm-ptn-ai-foundry-enterprise"

#   base_name               = local.base_name
#   location                = local.location
#   tags                    = local.tags
#   development_environment = local.development_environment

#   // use this collection to define the role templates for the different groups
#   role_templates = {
#     infra_admin = [
#       { role_name = "contributor", scope = "resource_group_id" },
#       { role_name = "azure_ai_administrator", scope = "resource_group_id" },
#       { role_name = "search_index_data_contributor", scope = "ai_search_service_id" },
#       { role_name = "cognitive_services_openai_user", scope = "openai_embedding_id" },
#       { role_name = "cognitive_services_openai_contributor", scope = "openai_chat_id" },
#       { role_name = "search_service_contributor", scope = "ai_search_service_id" },
#       { role_name = "storage_blob_data_contributor", scope = "storage_account_id" },
#       { role_name = "storage_file_data_privileged_contributor", scope = "storage_account_id" }
#     ]
#     ai_admin = [
#       { role_name = "owner", scope = "ai_hub_id" },
#       { role_name = "azure_ai_administrator", scope = "resource_group_id" },
#       { role_name = "search_index_data_contributor", scope = "ai_search_service_id" },
#       { role_name = "search_service_contributor", scope = "ai_search_service_id" },
#       { role_name = "cognitive_services_openai_contributor", scope = "openai_chat_id" },
#       { role_name = "cognitive_services_openai_user", scope = "openai_embedding_id" },
#       { role_name = "storage_blob_data_contributor", scope = "storage_account_id" },
#       { role_name = "storage_file_data_privileged_contributor", scope = "storage_account_id" }
#     ]
#   }

#   // Use this collection to assign users to each one of the roles defined in the role_templates collection
#   group_assignments = {
#     infra_admin = [
#       { type = "user", objectid = "a1234567-89ab-cdef-0123-456789abcdef", name = "Admin User" }
#     ]
#   }

#   // Use this configuration to define which layer to deploy, you can also choose to deploy only an specific layer
#   // Be aware that the layers are dependent on each other, so if you choose to deploy only one layer, 
#   // you will need to provide the required information for the other layers
#   deployment_config = {
#     deploy_network  = false
#     deploy_services = true
#     deploy_core     = true
#     deploy_identity = true
#     deploy_shared   = true
#   }

#   // you can add extra shared private links to the shared resources module
#   extra_shared_private_links = []
#   // you can add extra outbound rules to the ai hub module
#   extra_ai_hub_outbound_rules = {}
#   // this is the configureation for the core, search and ai services
#   search_config    = local.search_config
#   aiservice_config = local.aiservice_config
#   core_config      = local.core_config
#   network          = local.network

#   // use existing resource group name
#   use_existing_rg = true
#   existing_rg_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name # azurerm_resource_group.this.id # try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name

#   // use existing vnet and subnet id
#   existing_vnet_id = try(local.remote.networking.virtual_networks.spoke_project.virtual_network.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_network.id : var.vnet_id  
#   existing_subnet_id = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.subnet_name].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.subnet_name].resource.id : var.subnet_id

#   # subscription_id = "0b5b13b8-0ad7-4552-936f-8fae87e0633f"
#   depends_on = [
#     azurerm_resource_group.this
#   ]
# }
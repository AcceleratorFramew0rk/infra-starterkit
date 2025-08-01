module "avm_res_keyvault_vault" {
  source              = "Azure/avm-res-keyvault-vault/azurerm"
  # version             = "0.6.1"
  version = "0.10.0"

  tenant_id           = data.azurerm_client_config.current.tenant_id
  name                = "${module.naming.key_vault.name}-vm-${random_string.this.result}" # "${module.naming.key_vault.name_unique}${random_string.this.result}vm"  
  location            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location # azurerm_resource_group.this.0.location
  resource_group_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name # azurerm_resource_group.this.0.name

  network_acls = {
    default_action = "Allow"
  }

  role_assignments = {
    deployment_user_secrets = {
      role_definition_id_or_name = "Key Vault Secrets Officer"
      principal_id               = data.azurerm_client_config.current.object_id
    }
  }

  wait_for_rbac_before_secret_operations = {
    create = "60s"
  }

  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "virtual machine key vault" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "app"   
    }
  )
}

module "regions" {
  source  = "Azure/regions/azurerm"
  version = ">= 0.4.0"
}

locals {
  tags = {
    scenario = "windows_w_data_disk_and_public_ip"
  }
  regions = ["southeastasia", "southeastasia"]

  source_image_reference = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-g2"
    version   = "latest"
  }

  source_image_reference_linux = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"    
  }
}

resource "random_integer" "region_index" {
  max = length(local.regions) - 1
  min = 0
}

resource "random_integer" "zone_index" {
  max = length(module.regions.regions_by_name[local.regions[random_integer.region_index.result]].zones)
  min = 1
}

resource "azurerm_user_assigned_identity" "user" {
  location            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location # azurerm_resource_group.this.0.location
  name                = "${module.naming.user_assigned_identity.name_unique}-vmssw-${random_string.this.result}"   # module.naming.user_assigned_identity.name_unique
  resource_group_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name # azurerm_resource_group.this.0.name

}

# must be at least 6 characters long and less than 72 characters long
resource "random_password" "password" {
  length  = 64
  special = true
}

resource "azurerm_key_vault_secret" "this" {
  name         = "azureuser"
  value        = random_password.password.result
  key_vault_id = module.avm_res_keyvault_vault.resource_id 
}

module "get_valid_sku_for_deployment_region" {
  source = "Azure/avm-res-compute-virtualmachinescaleset/azurerm//modules/sku_selector"

  deployment_region = "southeastasia" # module.regions.regions[random_integer.region_index.result].name
}

# resource "tls_private_key" "this" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# This is the module call
module "vmss" {
  source  = "Azure/avm-res-compute-virtualmachinescaleset/azurerm"
  # version = "0.6.0"
  version = "0.7.1"  

  name = (
    length(replace("${module.naming.virtual_machine_scale_set.name}-${random_string.this.result}", "-", "")) > 9
    ? substr(replace("${module.naming.virtual_machine_scale_set.name}-${random_string.this.result}", "-", ""), 0, 9)
    : replace("${module.naming.virtual_machine_scale_set.name}-${random_string.this.result}", "-", "")
  )
  location            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location # azurerm_resource_group.this.0.location
  resource_group_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name # azurerm_resource_group.this.0.name
  enable_telemetry            = var.enable_telemetry
  platform_fault_domain_count = 1
  admin_password              = random_password.password.result # "P@ssw0rd1234!"
  sku_name                    = module.get_valid_sku_for_deployment_region.sku
  instances                   = var.instances # 2
  extension_protected_setting = {}
  user_data_base64            = null
  automatic_instance_repair   = null
  network_interface = [{
    name = "VMSS-NIC"
    ip_configuration = [{
      name      = "VMSS-IPConfig"
      subnet_id = try(local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.subnet_name].resource.id, null) != null ? local.remote.networking.virtual_networks.spoke_project.virtual_subnets[var.subnet_name].resource.id : var.subnet_id 
    }]
  }]
  os_profile = {
    custom_data = base64encode(file("init-script.ps1"))
    windows_configuration = {
      disable_password_authentication = false
      admin_username                  = "azureuser"
      license_type                    = "None"
      hotpatching_enabled             = false
      timezone                        = "Pacific Standard Time"
      provision_vm_agent              = true
      winrm_listener = [{
        protocol = "Http"
      }]
    }
  }
  source_image_reference = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
  extension = [
    {
      name                        = "CustomScriptExtension"
      publisher                   = "Microsoft.Compute"
      type                        = "CustomScriptExtension"
      type_handler_version        = "1.10"
      auto_upgrade_minor_version  = true
      failure_suppression_enabled = false
      settings                    = "{\"commandToExecute\":\"copy %SYSTEMDRIVE%\\\\AzureData\\\\CustomData.bin c:\\\\init-script.ps1 \\u0026 powershell -ExecutionPolicy Unrestricted -File %SYSTEMDRIVE%\\\\init-script.ps1\"}"
    },
    {
      name                        = "HealthExtension"
      publisher                   = "Microsoft.ManagedServices"
      type                        = "ApplicationHealthWindows"
      type_handler_version        = "1.0"
      auto_upgrade_minor_version  = true
      failure_suppression_enabled = false
      settings                    = "{\"port\":80,\"protocol\":\"http\",\"requestPath\":\"index.html\"}"
  }]
  managed_identities = {
    system_assigned = false
    user_assigned_resource_ids = [
      azurerm_user_assigned_identity.user.id
    ]
  }
  role_assignments = {
    role_assignment = {
      principal_id               = data.azurerm_client_config.current.object_id
      role_definition_id_or_name = "Reader"
      description                = "Assign the Reader role to the deployment user on this virtual machine scale set resource scope."
    }
  }
  
  tags        = merge(
    local.global_settings.tags,
    {
      purpose = "vmss" 
      project_code = try(local.global_settings.prefix, var.prefix) 
      env = try(local.global_settings.environment, var.environment) 
      zone = "project"
      tier = "app"   
    }
  )

  depends_on = [
    module.avm_res_keyvault_vault
  ]
}
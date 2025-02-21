module "natgateway" {
  source  = "Azure/avm-res-network-natgateway/azurerm"

  name                = "${module.naming.nat_gateway.name}-${random_string.this.result}" # module.naming.nat_gateway.name_unique
  enable_telemetry    = true
  location            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location # azurerm_resource_group.this.0.location
  resource_group_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name # azurerm_resource_group.this.0.name

}

module "subnet_nat_gateway_association" {
  source  = "AcceleratorFramew0rk/aaf/azurerm//modules/networking/terraform-azurerm-subnetnatgatewayassociation"

  nat_gateway_id                = module.natgateway.resource.id
  subnet_ids          = {
      subnet_id1 = module.virtual_subnet1["AzureFirewallSubnet"].resource.id
    }  
}

module "public_ip" {
  source  = "Azure/avm-res-network-publicipaddress/azurerm"
  version = "0.1.0"

  enable_telemetry    = var.enable_telemetry
  resource_group_name = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.name : local.global_settings.resource_group_name # azurerm_resource_group.this.0.name
  name                = module.naming.public_ip.name_unique
  location            = try(local.global_settings.resource_group_name, null) == null ? azurerm_resource_group.this.0.location : local.global_settings.location # azurerm_resource_group.this.0.location 
  sku = "Standard"
}

resource "azurerm_nat_gateway_public_ip_association" "nat_gategay_public_ip_association" {
  nat_gateway_id       = module.natgateway.resource.id
  public_ip_address_id = module.public_ip.public_ip_id
}



module "appservice" {
  source                = "./../app_service"   


  # Error: A resource with the ID "/subscriptions/0b5b13b8-0ad7-4552-936f-8fae87e0633f/resourceGroups/rg-as101-dev-platform/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net" already exists - to be managed via Terraform this resource needs to be imported into the State. Please see the resource documentation for "azurerm_private_dns_zone" for more information.

  subnet_name="AppServiceIntranetSubnet"
  ingress_subnet_name="WebIntranetSubnet" 
  resource_group_name  = var.resource_group_name 
  storage_account_name = var.storage_account_name   
  private_dns_zones_enabled = false

}

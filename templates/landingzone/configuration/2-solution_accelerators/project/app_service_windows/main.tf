
module "appservice" {
  source                = "./../app_service"   

  kind="Windows"
  dotnet_framework_version="v6.0" 
  resource_group_name  = var.resource_group_name 
  storage_account_name = var.storage_account_name   

}

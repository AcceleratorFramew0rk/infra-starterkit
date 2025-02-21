
module "appservice" {
  source                = "./../app_service"   

  subnet_name="AppServiceIntranetSubnet"
  ingress_subnet_name="WebIntranetSubnet" 
  resource_group_name  = var.resource_group_name 
  storage_account_name = var.storage_account_name   

}

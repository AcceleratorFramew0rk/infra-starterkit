resource "azurerm_resource_group" "this" {
  count = try(local.global_settings.resource_group_name, null) == null ? 1 : 0

  name     = "${module.naming.resource_group.name}-network-hub-internet-egress" 
  location = "${local.global_settings.location}" 
}




# resource "azurerm_log_analytics_workspace" "gcci_agency_workspace" {
#   count = try(var.gcci_agency_law_enabled, false) == true ? 1 : 0

#   name = try(local.log_analytics_workspace_name, null) != null ? local.log_analytics_workspace_name : "gcci-agency-workspace"
#   location = var.location
#   resource_group_name = "gcci-agency-law"
# }


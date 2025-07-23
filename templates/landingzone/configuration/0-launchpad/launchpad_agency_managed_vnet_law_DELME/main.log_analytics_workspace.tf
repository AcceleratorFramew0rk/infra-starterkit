resource "azurerm_log_analytics_workspace" "gcci_agency_workspace" {
  name = try(local.log_analytics_workspace_name, null) != null ? local.log_analytics_workspace_name : "gcci-agency-workspace"
  location = "${try(local.global_settings.location, var.location)}" 
  resource_group_name = "gcci-agency-law"
}




#!/bin/bash

RG_NAME=${PREFIX}-rg-launchpad
STORAGE_ACCOUNT_NAME_PREFIX="${PROJECT_CODE}stgtfstate"
STORAGE_ACCOUNT_INFO=$(az storage account list --resource-group $RG_NAME --query "[?contains(name, '$STORAGE_ACCOUNT_NAME_PREFIX')]" 2> /dev/null)
STG_NAME=$(echo "$STORAGE_ACCOUNT_INFO" | jq ".[0].name" -r)

echo $RG_NAME
echo $STG_NAME

ACCOUNT_INFO=$(az account show 2> /dev/null)
SUBSCRIPTION_ID=$(echo "$ACCOUNT_INFO" | jq ".id" -r)
LOG_ANALYTICS_WORKSPACE_RESOURCE_GROUP_NAME="gcci-agency-law"
LOG_ANALYTICS_WORKSPACE_NAME="gcci-agency-workspace"
echo $SUBSCRIPTION_ID



echo "-----------------------------------------------------------------------------"  
echo "Start terraform import commands"  
timestamp
echo "-----------------------------------------------------------------------------"  

MSYS_NO_PATHCONV=1 terraform init  -reconfigure \
-backend-config="resource_group_name=$RG_NAME" \
-backend-config="storage_account_name=$STG_NAME" \
-backend-config="container_name=0-launchpad" \
-backend-config="key=gcci-platform.tfstate"

echo "vnets:" 

# Variables for VNET Name
CONFIG_vnets_project_name="gcci-vnet-project"
CONFIG_vnets_devops_name="gcci-vnet-devops"
CONFIG_vnets_hub_ingress_internet_name=""
CONFIG_vnets_hub_egress_internet_name=""
CONFIG_vnets_hub_ingress_intranet_name=""
CONFIG_vnets_hub_egress_intranet_name=""
CONFIG_vnets_management_name=""

RESOURCE_GROUP_NAME=$(yq -r '.resource_group_name' $CONFIG_FILE_PATH)
echo $RESOURCE_GROUP_NAME
LOG_ANALYTICS_WORKSPACE_RESOURCE_GROUP_NAME=$(yq -r '.log_analytics_workspace_resource_group_name' $CONFIG_FILE_PATH)
echo $LOG_ANALYTICS_WORKSPACE_RESOURCE_GROUP_NAME
LOG_ANALYTICS_WORKSPACE_NAME=$(yq -r '.log_analytics_workspace_name' $CONFIG_FILE_PATH)
echo $LOG_ANALYTICS_WORKSPACE_NAME


# resource group
MSYS_NO_PATHCONV=1 terraform import "azurerm_resource_group.gcci_platform" "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/${RESOURCE_GROUP_NAME}" 
MSYS_NO_PATHCONV=1 terraform import "azurerm_resource_group.gcci_agency_law" "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/${LOG_ANALYTICS_WORKSPACE_RESOURCE_GROUP_NAME}" 

# virtual networks
if [[ "$CONFIG_vnets_hub_ingress_internet_name" != "" ]]; then
  MSYS_NO_PATHCONV=1 terraform import "azurerm_virtual_network.gcci_vnet_ingress_internet" "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/${RESOURCE_GROUP_NAME}/providers/Microsoft.Network/virtualNetworks/$CONFIG_vnets_hub_ingress_internet_name" 
fi

if [[ "$CONFIG_vnets_hub_egress_internet_name" != "" ]]; then
  MSYS_NO_PATHCONV=1 terraform import "azurerm_virtual_network.gcci_vnet_egress_internet" "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/${RESOURCE_GROUP_NAME}/providers/Microsoft.Network/virtualNetworks/$CONFIG_vnets_hub_egress_internet_name" 
fi

if [[ "$CONFIG_vnets_hub_ingress_intranet_name" != "" ]]; then
  MSYS_NO_PATHCONV=1 terraform import "azurerm_virtual_network.gcci_vnet_ingress_intranet" "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/${RESOURCE_GROUP_NAME}/providers/Microsoft.Network/virtualNetworks/$CONFIG_vnets_hub_ingress_intranet_name" 
fi

if [[ "$CONFIG_vnets_hub_egress_intranet_name" != "" ]]; then
  MSYS_NO_PATHCONV=1 terraform import "azurerm_virtual_network.gcci_vnet_egress_intranet" "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/${RESOURCE_GROUP_NAME}/providers/Microsoft.Network/virtualNetworks/$CONFIG_vnets_hub_egress_intranet_name" 
fi

if [[ "$CONFIG_vnets_project_name" != "" ]]; then
  MSYS_NO_PATHCONV=1 terraform import "azurerm_virtual_network.gcci_vnet_project" "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/${RESOURCE_GROUP_NAME}/providers/Microsoft.Network/virtualNetworks/$CONFIG_vnets_project_name" 
fi

if [[ "$CONFIG_vnets_management_name" != "" ]]; then
  MSYS_NO_PATHCONV=1 terraform import "azurerm_virtual_network.gcci_vnet_management" "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/${RESOURCE_GROUP_NAME}/providers/Microsoft.Network/virtualNetworks/$CONFIG_vnets_management_name" 
fi

if [[ "$CONFIG_vnets_devops_name" != "" ]]; then
  MSYS_NO_PATHCONV=1 terraform import "azurerm_virtual_network.gcci_vnet_devops" "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/${RESOURCE_GROUP_NAME}/providers/Microsoft.Network/virtualNetworks/$CONFIG_vnets_devops_name" 
fi

# log analytics workspace
MSYS_NO_PATHCONV=1 terraform import "azurerm_log_analytics_workspace.gcci_agency_workspace" "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/${LOG_ANALYTICS_WORKSPACE_RESOURCE_GROUP_NAME}/providers/Microsoft.OperationalInsights/workspaces/${LOG_ANALYTICS_WORKSPACE_NAME}" 

echo "-----------------------------------------------------------------------------"  
echo "End import gcci resources"  
timestamp
echo "-----------------------------------------------------------------------------"

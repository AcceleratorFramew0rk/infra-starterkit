#!/bin/bash

#------------------------------------------------------------------------
# working directory
#------------------------------------------------------------------------
# If $1 is unset or empty, default to /tf/avm
WORKING_DIR="${1:-/tf/avm}"
echo "Working Directory: ${WORKING_DIR}"

echo "getting the prefix from config.yaml"

#------------------------------------------------------------------------
# create launchpad storage account and containers
#------------------------------------------------------------------------

# define your prefix or project code
# CONFIG_FILE="${WORKING_DIR}/templates/landingzone/configuration/0-launchpad/scripts/config.yaml"
CONFIG_FILE="${WORKING_DIR}/config/config.yaml"
echo "Config file: ${CONFIG_FILE}"

PREFIX=$(yq  -r '.prefix' "${CONFIG_FILE}")
echo "getting the prefix from config.yaml"
# cd "${WORKING_DIR}/templates/landingzone/configuration/0-launchpad/launchpad_agency_managed_vnet"
cd "${WORKING_DIR}/scripts/bin"
pwd
# ./scripts/launchpad.sh $PREFIX
./launchpad.sh $PREFIX
if [ $? -eq 0 ]; then
    echo "launchpad.sh completed successfully."
else
    echo -e "\e[31mlaunchpad.sh failed. Exiting.\e[0m"
    exit 1
fi

#------------------------------------------------------------------------
# get global variables
#------------------------------------------------------------------------

# get storage account and resource group name
RG_NAME=${PREFIX}-rg-launchpad
STORAGE_ACCOUNT_NAME_PREFIX="${PROJECT_CODE}stgtfstate"
STORAGE_ACCOUNT_INFO=$(az storage account list --resource-group $RG_NAME --query "[?contains(name, '$STORAGE_ACCOUNT_NAME_PREFIX')]" 2> /dev/null)
STG_NAME=$(echo "$STORAGE_ACCOUNT_INFO" | jq ".[0].name" -r)

# get subscription id 
ACCOUNT_INFO=$(az account show 2> /dev/null)
SUBSCRIPTION_ID=$(echo "$ACCOUNT_INFO" | jq ".id" -r)
LOG_ANALYTICS_WORKSPACE_RESOURCE_GROUP_NAME=$(yq  -r '.log_analytics_workspace_resource_group_name' "${CONFIG_FILE}")
LOG_ANALYTICS_WORKSPACE_NAME=$(yq  -r '.log_analytics_workspace_name' "${CONFIG_FILE}")

echo $SUBSCRIPTION_ID
echo $PREFIX
echo $RG_NAME
echo $STG_NAME
echo $LOG_ANALYTICS_WORKSPACE_RESOURCE_GROUP_NAME
echo $LOG_ANALYTICS_WORKSPACE_NAME

export ARM_SUBSCRIPTION_ID="${SUBSCRIPTION_ID}"

#------------------------------------------------------------------------
# deploy agency managed virtual networks
#------------------------------------------------------------------------
# ** IMPORTANT: if required, modify config.yaml file to determine the vnets name and cidr ranage you want to deploy. 

cd "${WORKING_DIR}/templates/landingzone/configuration/0-launchpad/launchpad_agency_managed_vnet"

terraform init  -reconfigure \
-backend-config="resource_group_name=$RG_NAME" \
-backend-config="storage_account_name=$STG_NAME" \
-backend-config="container_name=0-launchpad" \
-backend-config="key=gcci-platform.tfstate"

if [ $? -eq 0 ]; then
    echo "Terraform init completed successfully."
else
    echo -e "\e[31mTerraform init failed. Exiting.\e[0m"
    exit 1
fi

terraform plan

if [ $? -eq 0 ]; then
    echo "Terraform plan completed successfully."
else
    echo -e "\e[31mTerraform plan failed. Exiting.\e[0m"
    exit 1
fi

terraform apply -auto-approve

if [ $? -eq 0 ]; then
    echo "Terraform apply completed successfully."
else
    echo -e "\e[31mTerraform apply failed. Exiting.\e[0m"
    exit 1
fi


#------------------------------------------------------------------------
# import log analytics workspace - using launchpad folder
#------------------------------------------------------------------------

cd "${WORKING_DIR}/templates/landingzone/configuration/0-launchpad/launchpad_agency_managed_vnet_law"

terraform init  -reconfigure \
-backend-config="resource_group_name=$RG_NAME" \
-backend-config="storage_account_name=$STG_NAME" \
-backend-config="container_name=0-launchpad" \
-backend-config="key=gcci-platform.tfstate"
if [ $? -eq 0 ]; then
    echo "terraform init completed successfully."
else
    echo -e "\e[31mTerraform init failed. Exiting.\e[0m"
    exit 1
fi

terraform import "azurerm_log_analytics_workspace.gcci_agency_workspace" "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/${LOG_ANALYTICS_WORKSPACE_RESOURCE_GROUP_NAME}/providers/Microsoft.OperationalInsights/workspaces/${LOG_ANALYTICS_WORKSPACE_NAME}" 
if [ $? -eq 0 ]; then
    echo "terraform import completed successfully."
else
    echo -e "\e[31mTerraform import azurerm_log_analytics_workspace failed. Exiting.\e[0m"
    exit 1
fi
# process terraform based on settings.yaml
pwd


#------------------------------------------------------------------------
# generate the nsg configuration
#------------------------------------------------------------------------

# cd "${WORKING_DIR}/templates/landingzone/configuration/0-launchpad/launchpad_agency_managed_vnet"
cd "${WORKING_DIR}/scripts/bin"
# ./scripts/nsg.sh "${WORKING_DIR}"
./nsg.sh "${WORKING_DIR}"
if [ $? -eq 0 ]; then
    echo "nsg.sh completed successfully."
else
    echo -e "\e[31mnsg.sh failed. Exiting.\e[0m"
    exit 1
fi

echo "Import script completed successfully."
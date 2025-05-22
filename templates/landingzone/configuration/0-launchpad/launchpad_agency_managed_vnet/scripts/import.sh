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
CONFIG_FILE="${WORKING_DIR}/templates/landingzone/configuration/0-launchpad/scripts/config.yaml"
echo "Config file: ${CONFIG_FILE}"

PREFIX=$(yq  -r '.prefix' "${CONFIG_FILE}")
echo "getting the prefix from config.yaml"
# cd /tf/avm/templates/landingzone/configuration/0-launchpad/launchpad_healthcare
cd "${WORKING_DIR}/templates/landingzone/configuration/0-launchpad/launchpad_agency_managed_vnet"
pwd
# ./scripts/launchpad.sh $PREFIX

#------------------------------------------------------------------------
# launchpad logic
#------------------------------------------------------------------------

# Generate storage acc name to store state file
LOC="southeastasia"
PROJECT_CODE="${PREFIX}"
RND_NUM=$(env LC_CTYPE=C tr -dc 'a-z' </dev/urandom | fold -w 3 | head -n 1)

RG_NAME="${PROJECT_CODE}-rg-launchpad"
STG_NAME="${PROJECT_CODE}stgtfstate${RND_NUM}"
STG_NAME="${STG_NAME//-/}"
CONTAINER1="0-launchpad"
CONTAINER2="1-landingzones"
CONTAINER3="2-solution-accelerators"

# Check if the resource group already exists
az group show --name $RG_NAME > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo -p "ERROR: Resource group $RG_NAME already exists. Exiting."
    exit 1
else
    # If the resource group does not exist, attempt to create it
    az group create --name $RG_NAME --location $LOC
    if [ $? -eq 0 ]; then
        echo "Resource group $RG_NAME created successfully."
    else
        echo -p "ERROR: Failed to create resource group $RG_NAME. Exiting."
        exit 1
    fi
fi

# Create Storage account and containers for storing state files
az storage account create --name $STG_NAME --resource-group $RG_NAME --location $LOC --sku Standard_LRS --kind StorageV2 --allow-blob-public-access true --min-tls-version TLS1_2
if [ $? -eq 0 ]; then
    echo -p "ERROR: Failed to create storage. Exiting."
    exit 1
fi
az storage container create --account-name $STG_NAME --name $CONTAINER1 --public-access blob --fail-on-exist
if [ $? -eq 0 ]; then
    echo -p "ERROR: Failed to create container $CONTAINER1. Exiting."
    exit 1
fi
az storage container create --account-name $STG_NAME --name $CONTAINER2 --public-access blob --fail-on-exist
if [ $? -eq 0 ]; then
    echo -p "ERROR: Failed to create container $CONTAINER2. Exiting."
    exit 1
fi
az storage container create --account-name $STG_NAME --name $CONTAINER3 --public-access blob --fail-on-exist
if [ $? -eq 0 ]; then
    echo -p "ERROR: Failed to create container $CONTAINER3. Exiting."
    exit 1
fi


#------------------------------------------------------------------------
# end launchpad logic
#------------------------------------------------------------------------


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
LOG_ANALYTICS_WORKSPACE_RESOURCE_GROUP_NAME="gcci-agency-law"
LOG_ANALYTICS_WORKSPACE_NAME="gcci-agency-workspace"

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

# cd /tf/avm/templates/landingzone/configuration/0-launchpad/launchpad_healthcare
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
# cd /tf/avm/templates/landingzone/configuration/0-launchpad/launchpad_healthcare_law
# cd "${WORKING_DIR}/templates/landingzone/configuration/0-launchpad/launchpad_healthcare_law"
cd "${WORKING_DIR}/templates/landingzone/configuration/0-launchpad/launchpad_agency_managed_vnet_law"

terraform init  -reconfigure \
-backend-config="resource_group_name=$RG_NAME" \
-backend-config="storage_account_name=$STG_NAME" \
-backend-config="container_name=0-launchpad" \
-backend-config="key=gcci-platform.tfstate"

terraform import "azurerm_log_analytics_workspace.gcci_agency_workspace" "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/${LOG_ANALYTICS_WORKSPACE_RESOURCE_GROUP_NAME}/providers/Microsoft.OperationalInsights/workspaces/${LOG_ANALYTICS_WORKSPACE_NAME}" 

# process terraform based on settings.yaml
pwd


#------------------------------------------------------------------------
# generate the nsg configuration
#------------------------------------------------------------------------
# cd /tf/avm/templates/landingzone/configuration/0-launchpad/launchpad_healthcare
# cd "${WORKING_DIR}/templates/landingzone/configuration/0-launchpad/launchpad_healthcare"
cd "${WORKING_DIR}/templates/landingzone/configuration/0-launchpad/launchpad_agency_managed_vnet"
./scripts/nsg.sh "${WORKING_DIR}"
if [ $? -eq 0 ]; then
    echo "nsg.sh completed successfully."
else
    echo -e "\e[31mnsg.sh failed. Exiting.\e[0m"
    exit 1
fi

echo "Import script completed successfully."
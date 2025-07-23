#!/bin/bash

#------------------------------------------------------------------------
# working directory
#------------------------------------------------------------------------
# If $1 is unset or empty, default to /tf/avm
WORKING_DIR="${1:-/tf/avm}"

# cannot change mode in github pipeline
# sudo chmod -R -f 777 "${WORKING_DIR}/templates/landingzone/configuration"


#------------------------------------------------------------------------
# create launchpad storage account and containers
#------------------------------------------------------------------------

# define your prefix or project code
# PREFIX=$(yq  -r '.prefix' "${WORKING_DIR}/config/config.yaml")
PREFIX=$(yq  -r '.prefix' "${WORKING_DIR}/config/config.yaml")

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

echo $RG_NAME
echo $STG_NAME
echo $SUBSCRIPTION_ID

export ARM_SUBSCRIPTION_ID="${SUBSCRIPTION_ID}"

#------------------------------------------------------------------------
# import log analytics workspace - using launchpad_healthcare_law folder
#------------------------------------------------------------------------
# cd /tf/avm/templates/landingzone/configuration/0-launchpad/launchpad_healthcare_law
cd "${WORKING_DIR}/templates/landingzone/configuration/0-launchpad/launchpad_healthcare_law"

terraform init  -reconfigure \
-backend-config="resource_group_name=$RG_NAME" \
-backend-config="storage_account_name=$STG_NAME" \
-backend-config="container_name=0-launchpad" \
-backend-config="key=gcci-platform.tfstate"

# remove the existing log analytics workspace from the state file
terraform state rm azurerm_log_analytics_workspace.gcci_agency_workspace

# import the log analytics workspace into the state file
terraform import "azurerm_log_analytics_workspace.gcci_agency_workspace" "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/${LOG_ANALYTICS_WORKSPACE_RESOURCE_GROUP_NAME}/providers/Microsoft.OperationalInsights/workspaces/${LOG_ANALYTICS_WORKSPACE_NAME}" 


# process terraform based on settings.yaml
pwd

#------------------------------------------------------------------------
# generate the nsg configuration
#------------------------------------------------------------------------
# cd /tf/avm/templates/landingzone/configuration/0-launchpad/launchpad_healthcare
cd "${WORKING_DIR}/templates/landingzone/configuration/0-launchpad/launchpad_healthcare"
./scripts/nsg.sh "${WORKING_DIR}"
if [ $? -eq 0 ]; then
    echo "nsg.sh completed successfully."
else
    echo -e "\e[31mnsg.sh failed. Exiting.\e[0m"
    exit 1
fi

echo "Import update script completed successfully."
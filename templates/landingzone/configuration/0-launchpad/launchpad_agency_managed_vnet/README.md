# set the prefix here

sudo chmod -R -f 777 /tf/avm/templates/landingzone/configuration

# create launchpad storage account and containers
cd /tf/avm/templates/landingzone/configuration/0-launchpad/launchpad_healthcare

# define your prefix or project code
PREFIX=$(yq  -r '.prefix' /tf/avm/templates/landingzone/configuration/0-launchpad/scripts/config.yaml)
echo $PREFIX

# create launchpad storage account
./scripts/launchpad.sh $PREFIX

# TODO: Remove - not required - replace the storage account and resource group name
# ./scripts/replace.sh $PREFIX

cd /tf/avm/templates/landingzone/configuration/0-launchpad/launchpad_healthcare

# get storage account and resource group name
RG_NAME=${PREFIX}-rg-launchpad
STORAGE_ACCOUNT_NAME_PREFIX="${PROJECT_CODE}stgtfstate"
STORAGE_ACCOUNT_INFO=$(az storage account list --resource-group $RG_NAME --query "[?contains(name, '$STORAGE_ACCOUNT_NAME_PREFIX')]" 2> /dev/null)
STG_NAME=$(echo "$STORAGE_ACCOUNT_INFO" | jq ".[0].name" -r)

echo $RG_NAME
echo $STG_NAME

# deploy virtual networks

terraform init  -reconfigure \
-backend-config="resource_group_name=$RG_NAME" \
-backend-config="storage_account_name=$STG_NAME" \
-backend-config="container_name=0-launchpad" \
-backend-config="key=gcci-platform.tfstate"

terraform plan

terraform apply -auto-approve


# import log analytics workspace - using launchpad folder "/tf/avm/templates/landingzone/configuration/0-launchpad/launchpad"

ACCOUNT_INFO=$(az account show 2> /dev/null)
SUBSCRIPTION_ID=$(echo "$ACCOUNT_INFO" | jq ".id" -r)
LOG_ANALYTICS_WORKSPACE_RESOURCE_GROUP_NAME="gcci-agency-law"
LOG_ANALYTICS_WORKSPACE_NAME="gcci-agency-workspace"
echo $SUBSCRIPTION_ID

cd /tf/avm/templates/landingzone/configuration/0-launchpad/launchpad_healthcare_law

terraform init  -reconfigure \
-backend-config="resource_group_name=$RG_NAME" \
-backend-config="storage_account_name=$STG_NAME" \
-backend-config="container_name=0-launchpad" \
-backend-config="key=gcci-platform.tfstate"


terraform import "azurerm_log_analytics_workspace.gcci_agency_workspace" "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/${LOG_ANALYTICS_WORKSPACE_RESOURCE_GROUP_NAME}/providers/Microsoft.OperationalInsights/workspaces/${LOG_ANALYTICS_WORKSPACE_NAME}" 


# TODO: generate the subnets detail, else hardcode in the config.yaml file

# generate the nsg configuration after vnet is created.
cd /tf/avm/templates/landingzone/configuration/0-launchpad/launchpad_healthcare
./scripts/nsg.sh

# create virtual networks for non gcc environment
# ** IMPORTANT: if required, modify config.yaml file to determine the vnets name and cidr ranage you want to deploy. 


# to continue, goto landing zone folder and follow the steps in README.md

cd /tf/avm/templates/landingzone/configuration/1-landingzones
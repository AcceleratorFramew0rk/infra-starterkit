#!/bin/bash

sudo chmod -R -f 777 /tf/avm/templates/landingzone/configuration


#------------------------------------------------------------------------
# create launchpad storage account and containers
#------------------------------------------------------------------------

# define your prefix or project code
PREFIX=$(yq  -r '.prefix' /tf/avm/templates/landingzone/configuration/0-launchpad/scripts/config.yaml)

cd /tf/avm/templates/landingzone/configuration/0-launchpad/launchpad_healthcare
./scripts/launchpad.sh $PREFIX


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
# deploy agency managed virtual networks
#------------------------------------------------------------------------
# ** IMPORTANT: if required, modify config.yaml file to determine the vnets name and cidr ranage you want to deploy. 

cd /tf/avm/templates/landingzone/configuration/0-launchpad/launchpad_healthcare

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
cd /tf/avm/templates/landingzone/configuration/0-launchpad/launchpad_healthcare_law

terraform init  -reconfigure \
-backend-config="resource_group_name=$RG_NAME" \
-backend-config="storage_account_name=$STG_NAME" \
-backend-config="container_name=0-launchpad" \
-backend-config="key=gcci-platform.tfstate"

terraform import "azurerm_log_analytics_workspace.gcci_agency_workspace" "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/${LOG_ANALYTICS_WORKSPACE_RESOURCE_GROUP_NAME}/providers/Microsoft.OperationalInsights/workspaces/${LOG_ANALYTICS_WORKSPACE_NAME}" 


# #------------------------------------------------------------------------
# # create config.yaml file
# #------------------------------------------------------------------------

# LANDINGZONE_TYPE="application"
# if [[ "$LANDINGZONE_TYPE" == "application"  || "$LANDINGZONE_TYPE" == "1" ]]; then

# # Output the variables to a text file (input.yaml)
# cat <<EOF > ./../config/input.yaml
# subscription_id: "${SUB_ID}"
# prefix: "${PREFIX}"
# is_prefix: false
# is_single_resource_group: false
# environment: "${ENVIRONMENT}"
# vnets:
#   hub_ingress_internet: 
#     name:   
#     cidr: 
#   hub_egress_internet:  
#     name:   
#     cidr: 
#   hub_ingress_intranet:  
#     name:  
#     cidr: 
#   hub_egress_intranet:  
#     name:    
#     cidr: 
#   management:  
#     name:     
#     cidr: 
#   project:  
#     name: "$VNET_PROJECT_NAME"
#     cidr: "$GCCI_VNET_PROJECT_CIDR"
#   devops:  
#     name: "$VNET_DEVOPS_NAME"  
#     cidr: "$GCCI_VNET_DEVOPS_CIDR"  
# EOF

# else
# # Output the variables to a text file (input.yaml)
# cat <<EOF > ./../config/input.yaml
# subscription_id: "${SUB_ID}"
# prefix: "${PREFIX}"
# is_prefix: false
# is_single_resource_group: false
# environment: "${ENVIRONMENT}"
# vnets:
#   hub_ingress_internet: 
#     name: "$VNET_HUB_INGRESS_INTERNET_NAME" 
#     cidr: "$VNET_HUB_INGRESS_INTERNET_CIDR"
#   hub_egress_internet:  
#     name: "$VNET_HUB_EGRESS_INTERNET_NAME"  
#     cidr: "$VNET_HUB_EGRESS_INTERNET_CIDR"
#   hub_ingress_intranet:  
#     name: "$VNET_HUB_INGRESS_INTRANET_NAME"
#     cidr: "$VNET_HUB_INGRESS_INTRANET_CIDR"
#   hub_egress_intranet:  
#     name: "$VNET_HUB_EGRESS_INTRANET_NAME" 
#     cidr: "$VNET_HUB_EGRESS_INTRANET_CIDR"
#   management:  
#     name: "$VNET_MANAGEMENT_NAME"    
#     cidr: "$VNET_MANAGEMENT_CIDR" 
#   project:  
#     name: 
#     cidr: 
#   devops:  
#     name: 
#     cidr: 
# EOF

# fi


# # render config.yaml
# echo "render config.yaml"

# # goto the top level folder
# cd /tf/avm
# # "Usage: python3 render_config.py <settings_yaml_file_path>
# python3 /tf/avm/scripts/lib/render_config.py $SETTINGS_YAML_FILE_PATH $LANDINGZONE_TYPE
# if [ $? -ne 0 ]; then
#   echo "Terraform init failed. Exiting."
#   echo -e "\e[31mrender_config execution failed. Exiting.\e[0m"
#   exit 1
# fi
# # perform copy
# echo "copy output_config.yaml to working directory"
# cp "/tf/avm/scripts/config/output_config.yaml" "/tf/avm/templates/landingzone/configuration/0-launchpad/scripts/config.yaml"


# process terraform based on settings.yaml
pwd


#------------------------------------------------------------------------
# generate the nsg configuration
#------------------------------------------------------------------------
cd /tf/avm/templates/landingzone/configuration/0-launchpad/launchpad_healthcare_law
./scripts/nsg.sh


echo "Import scriptcompleted successfully."
#!/bin/bash

#------------------------------------------------------------------------
# USAGE:
# cd /tf/avm/scripts/bin # ** must run from this directory
# ./install.sh
#------------------------------------------------------------------------


#------------------------------------------------------------------------
# prepare the environment
#------------------------------------------------------------------------

WORKING_DIR="/tf/avm"

echo "PREFIX: $PREFIX"
echo "RESOURCE GROUP NAME: $RESOURCE_GROUP_NAME"
echo "Log Analytics Workspace Resource Group Name: $LOG_ANALYTICS_WORKSPACE_RESOURCE_GROUP_NAME"
echo "Log Analytics Workspace Name: $LOG_ANALYTICS_WORKSPACE_NAME"
echo "VNET Project Name: $VNET_PROJECT_NAME"
echo "VNET DevOps Name: $VNET_DEVOPS_NAME"
echo "The CIDR of the GCCI Project Virtual Network is: $GCCI_VNET_PROJECT_CIDR"
echo "The CIDR of the GCCI DevOps Virtual Network is: $GCCI_VNET_DEVOPS_CIDR"
echo "SETTINGS YAML FILE PATH: $SETTINGS_YAML_FILE_PATH"

# Additional installation steps can go here

# #------------------------------------------------------------------------
# # get configuration file path, resource group name, storage account name, subscription id, subscription name
# #------------------------------------------------------------------------

# get current subscription id and name
ACCOUNT_INFO=$(az account show 2> /dev/null)
if [[ $? -ne 0 ]]; then
    echo " "    
    echo -e "\e[31mNo subscription available. Please check your login. Exiting.\e[0m"    
    exit
fi
SUB_ID=$(echo "$ACCOUNT_INFO" | jq ".id" -r)
SUB_NAME=$(echo "$ACCOUNT_INFO" | jq ".name" -r)
USER_NAME=$(echo "$ACCOUNT_INFO" | jq ".user.name" -r)
SUBSCRIPTION_ID="${SUB_ID}" 

# get resource group and storage account name
RG_NAME="${PREFIX}-rg-launchpad"
STG_NAME=$(az storage account list --resource-group $RG_NAME --query "[?contains(name, '${PREFIX}stgtfstate')].[name]" -o tsv 2>/dev/null | head -n 1)

CONFIG_YAML_FILE_PATH="${WORKING_DIR}/config/config.yaml"

echo "PREFIX: ${PREFIX}"
echo "RESOURCE GROUP NAME: ${RESOURCE_GROUP_NAME}"
echo "ENVIRONMENT: ${ENVIRONMENT}"
echo "Subscription Id: ${SUB_ID}"
echo "Subscription Name: ${SUB_NAME}"
# echo "Storage Account Name: ${STG_NAME}"
echo "Resource Group Name: ${RG_NAME}"
echo "Config Yaml File Path: ${CONFIG_YAML_FILE_PATH}"

export ARM_SUBSCRIPTION_ID="${SUBSCRIPTION_ID}"

#------------------------------------------------------------------------
# end get configuration file path, resource group name, storage account name, subscription id, subscription name
#------------------------------------------------------------------------


if [[ "$LANDINGZONE_TYPE" == "application"  || "$LANDINGZONE_TYPE" == "1" ]]; then

# Output the variables to a text file (input.yaml)
cat <<EOF > ./../config/input.yaml
subscription_id: "${SUB_ID}"
resource_group_name: "${RESOURCE_GROUP_NAME}"
log_analytics_workspace_resource_group_name: "${LOG_ANALYTICS_WORKSPACE_RESOURCE_GROUP_NAME}"  
log_analytics_workspace_name: "${LOG_ANALYTICS_WORKSPACE_NAME}" 
prefix: "${PREFIX}"
is_prefix: true
is_single_resource_group: true
environment: "${ENVIRONMENT}"
settings_yaml_file_path: "${SETTINGS_YAML_FILE_PATH}"
config_yaml_file_path: "${CONFIG_YAML_FILE_PATH}"
vnets:
  hub_ingress_internet: 
    name:   
    cidr: 
  hub_egress_internet:  
    name:   
    cidr: 
  hub_ingress_intranet:  
    name:  
    cidr: 
  hub_egress_intranet:  
    name:    
    cidr: 
  management:  
    name:     
    cidr: 
  project:  
    name: "$VNET_PROJECT_NAME"
    cidr: "$GCCI_VNET_PROJECT_CIDR"
  devops:  
    name: "$VNET_DEVOPS_NAME"  
    cidr: "$GCCI_VNET_DEVOPS_CIDR"  
EOF

else
# Output the variables to a text file (input.yaml)
VNET_HUB_INGRESS_INTERNET_NAME="gcci-vnet-ingress-internet"
VNET_HUB_EGRESS_INTERNET_NAME=""
VNET_HUB_INGRESS_INTRANET_NAME="gcci-vnet-ingress-intranet"
VNET_HUB_EGRESS_INTRANET_NAME=""
VNET_MANAGEMENT_NAME="gcci-vnet-management"

cat <<EOF > ./../config/input.yaml
subscription_id: "${SUB_ID}"
resource_group_name: "${RESOURCE_GROUP_NAME}"
log_analytics_workspace_resource_group_name: "${LOG_ANALYTICS_WORKSPACE_RESOURCE_GROUP_NAME}"  
log_analytics_workspace_name: "${LOG_ANALYTICS_WORKSPACE_NAME}" 
prefix: "${PREFIX}"
is_prefix: true
is_single_resource_group: true
environment: "${ENVIRONMENT}"
settings_yaml_file_path: "${SETTINGS_YAML_FILE_PATH}"
config_yaml_file_path: "${CONFIG_YAML_FILE_PATH}"
vnets:
  hub_ingress_internet: 
    name: "$VNET_HUB_INGRESS_INTERNET_NAME" 
    cidr: "$VNET_HUB_INGRESS_INTERNET_CIDR"
  hub_egress_internet:  
    name: 
    cidr: 
  hub_ingress_intranet:  
    name: "$VNET_HUB_INGRESS_INTRANET_NAME"
    cidr: "$VNET_HUB_INGRESS_INTRANET_CIDR"
  hub_egress_intranet:  
    name: 
    cidr: 
  management:  
    name: "$VNET_MANAGEMENT_NAME"    
    cidr: "$VNET_MANAGEMENT_CIDR" 
  project:  
    name: 
    cidr: 
  devops:  
    name: 
    cidr: 
EOF



# cat <<EOF > ./../config/input.yaml
# subscription_id: "${SUB_ID}"
# resource_group_name: "${RESOURCE_GROUP_NAME}"
# prefix: "${PREFIX}"
# is_prefix: true
# is_single_resource_group: true
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

fi


#------------------------------------------------------------------------
# render config.yaml
#------------------------------------------------------------------------

echo "render config.yaml"

# "Usage: python3 render_config.py <settings_yaml_file_path> <landingzone_type>
python3 ./../lib/render_config.py $SETTINGS_YAML_FILE_PATH $LANDINGZONE_TYPE
if [ $? -ne 0 ]; then
  echo "Generate Config failed. Exiting."
  echo -e "\e[31mrender_config execution failed. Exiting.\e[0m"
  exit 1
else
  echo "Generate Config completed successfully."
  echo -e "\e[32mrender_config execution completed successfully.\e[0m"
  # perform copy
  echo "copy output_config.yaml to working directory"
  # cp "$(dirname "$0")/../config/output_config.yaml" "$CONFIG_YAML_FILE_PATH"
  cp "$(dirname "$0")/../output/output_config.yaml" "$CONFIG_YAML_FILE_PATH"
  echo "  "
  echo "Verify the config.yaml file in this folder: $CONFIG_YAML_FILE_PATH"
  echo "  "  
fi



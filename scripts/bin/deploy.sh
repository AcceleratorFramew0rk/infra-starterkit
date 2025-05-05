#!/bin/bash

#------------------------------------------------------------------------
# USAGE:
# cd /tf/avm/scripts/bin # ** must run from this directory
# ./install.sh
#------------------------------------------------------------------------


#------------------------------------------------------------------------
# prepare the environment
#------------------------------------------------------------------------
# Source the prompt.sh file to include its functions and variables
# Source the prompt.sh file to include its functions and variables
# source ./prompt.sh
# source ./prepare_environment.sh

# goto working directory
cd /tf/avm/scripts/bin

echo "You are currently in the directory: $(pwd)"

# Source utility scripts
source "$(dirname "$0")/../lib/prompt.sh"
source "$(dirname "$0")/../lib/prepare_environment.sh"

echo "PREFIX: $PREFIX"
echo "RESOURCE GROUP NAME: $RESOURCE_GROUP_NAME"
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
    echo "no subscription"
    exit
fi
SUB_ID=$(echo "$ACCOUNT_INFO" | jq ".id" -r)
SUB_NAME=$(echo "$ACCOUNT_INFO" | jq ".name" -r)
USER_NAME=$(echo "$ACCOUNT_INFO" | jq ".user.name" -r)
SUBSCRIPTION_ID="${SUB_ID}" 

# get resource group and storage account name
RG_NAME="${PREFIX}-rg-launchpad"
STG_NAME=$(az storage account list --resource-group $RG_NAME --query "[?contains(name, '${PREFIX}stgtfstate')].[name]" -o tsv 2>/dev/null | head -n 1)

CONFIG_YAML_FILE_PATH="/tf/avm/templates/landingzone/configuration/0-launchpad/scripts/config.yaml"

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
prefix: "${PREFIX}"
is_prefix: true
is_single_resource_group: true
environment: "${ENVIRONMENT}"
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
prefix: "${PREFIX}"
is_prefix: true
is_single_resource_group: true
environment: "${ENVIRONMENT}"
settings_yaml_file_path: "${SETTINGS_YAML_FILE_PATH}"
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

fi


#------------------------------------------------------------------------
# render config.yaml
#------------------------------------------------------------------------

echo "render config.yaml"

# "Usage: python3 render_config.py <settings_yaml_file_path>
python3 ./../lib/render_config.py $SETTINGS_YAML_FILE_PATH $LANDINGZONE_TYPE
if [ $? -ne 0 ]; then
  echo "Terraform init failed. Exiting."
  echo -e "\e[31mrender_config execution failed. Exiting.\e[0m"
  exit 1
fi
# perform copy
echo "copy output_config.yaml to working directory"
cp "$(dirname "$0")/../config/output_config.yaml" "$CONFIG_YAML_FILE_PATH"
echo "  "
echo "Verify the config.yaml file in this folder: $CONFIG_YAML_FILE_PATH"
echo "  "



#------------------------------------------------------------------------
## 0. Launchpad - create launchpad storage account and containers
### - set prefix and configuration
### - modify /tf/avm/templates/landingzone/configuration/0-launchpad/scripts/config.yaml according to your vnet and subnet requirements
### ** Follow the instruction to enter the below information
### Prefix, Resource Group Name, VNet Project Name and CIDR, VNet DevOps Name and CIDR, Landing Zone Type, <Your Settings File>
#------------------------------------------------------------------------

tfexe import -path=/tf/avm/templates/landingzone/configuration/0-launchpad/launchpad_healthcare
if [ $? -ne 0 ]; then
  echo -e "     "
  echo -e "\e[31m0-Launchpad failed. Exiting.\e[0m"
  exit 1
fi

#------------------------------------------------------------------------
## 1. Infra and Application Landing zone and networking
# terraform init and apply the below folders:
# /tf/avm/templates/landingzone/configuration/1-landingzones/application/networking_spoke_devops
# /tf/avm/templates/landingzone/configuration/1-landingzones/application/networking_spoke_project
# /tf/avm/templates/landingzone/configuration/1-landingzones/application/networking_peering_project_devops
#------------------------------------------------------------------------
# tfexe apply run-all -include=/tf/avm/AI_Foundry_LZ_single_resource_group.hcl

if [[ "$LANDINGZONE_TYPE" == "application"  || "$LANDINGZONE_TYPE" == "1" ]]; then

  tfexe apply -path=/tf/avm/templates/landingzone/configuration/1-landingzones/application/networking_spoke_project
  if [ $? -ne 0 ]; then
    echo -e "     "
    echo -e "\e[31mCreate 1-Landing Zone networking_spoke_project failed. Exiting.\e[0m"
    exit 1
  fi

  tfexe apply -path=/tf/avm/templates/landingzone/configuration/1-landingzones/application/networking_spoke_devops
  if [ $? -ne 0 ]; then
    echo -e "     "
    echo -e "\e[31mCreate 1-Landing Zone networking_spoke_devops failed. Exiting.\e[0m"
    exit 1
  fi

  tfexe apply -path=/tf/avm/templates/landingzone/configuration/1-landingzones/application/networking_peering_project_devops
  if [ $? -ne 0 ]; then
    echo -e "     "
    echo -e "\e[31mCreate 1-Landing Zone networking_peering_project_devops failed. Exiting.\e[0m"
    exit 1
  fi

else

  tfexe apply -path=/tf/avm/templates/landingzone/configuration/1-landingzones/platform/networking_hub_internet_ingress
  if [ $? -ne 0 ]; then
    echo -e "     "
    echo -e "\e[31mCreate 1-Landing Zone networking_hub_internet_ingress failed. Exiting.\e[0m"
    exit 1
  fi

  tfexe apply -path=/tf/avm/templates/landingzone/configuration/1-landingzones/platform/networking_hub_intranet_ingress
  if [ $? -ne 0 ]; then
    echo -e "     "
    echo -e "\e[31mCreate 1-Landing Zone networking_hub_intranet_ingress failed. Exiting.\e[0m"
    exit 1
  fi

  tfexe apply -path=/tf/avm/templates/landingzone/configuration/1-landingzones/platform/networking_spoke_management
  if [ $? -ne 0 ]; then
    echo -e "     "
    echo -e "\e[31mCreate 1-Landing Zone networking_spoke_management failed. Exiting.\e[0m"
    exit 1
  fi

  tfexe apply -path=/tf/avm/templates/landingzone/configuration/1-landingzones/application/networking_peering
  if [ $? -ne 0 ]; then
    echo -e "     "
    echo -e "\e[31mCreate 1-Landing Zone networking_peering failed. Exiting.\e[0m"
    exit 1
  fi

fi

#------------------------------------------------------------------------
# 2- solution accelerators
# deploy azure resources based on the settings.yaml file
# USAGE:
# exec_solution_accelerators.sh <path_to_settings_yaml_file> <path_to_config_yaml_file> <landingzone_type>
#------------------------------------------------------------------------
echo "deploy azure resources - 2-solution accelerators"

cd /tf/avm/scripts/bin

./../lib/deploy_azure_resources.sh $SETTINGS_YAML_FILE_PATH $CONFIG_YAML_FILE_PATH $LANDINGZONE_TYPE

if [ $? -ne 0 ]; then
  echo -e "     "
  echo -e "\e[31mDeploy azure_resources failed. Exiting.\e[0m"
  exit 1
else
  echo -e "\e[32mall azure resources deployed successfully!\e[0m"  
fi





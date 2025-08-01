#!/bin/bash

#------------------------------------------------------------------------
# USAGE:
# cd /tf/avm/scripts/bin # ** must run from this directory
# ./deploy.sh
#------------------------------------------------------------------------


WORKING_DIR="/tf/avm"

# goto working directory
cd "${WORKING_DIR}/scripts/bin"

echo "You are currently in the directory: $(pwd)"

# Source utility scripts
#------------------------------------------------------------------------
# pre - prepare the environment
#------------------------------------------------------------------------
source "$(dirname "$0")/../lib/prompt.sh"
source "$(dirname "$0")/../lib/prepare_environment.sh"
#------------------------------------------------------------------------
# pre - generate config
#------------------------------------------------------------------------
source "$(dirname "$0")/../lib/generate_config.sh"

#------------------------------------------------------------------------
## 0. Launchpad - create launchpad storage account and containers
### - set prefix and configuration
### - modify /tf/avm/config/config.yaml according to your vnet and subnet requirements
### ** Follow the instruction to enter the below information
### Prefix, Resource Group Name, VNet Project Name and CIDR, VNet DevOps Name and CIDR, Landing Zone Type, <Your Settings File>
#------------------------------------------------------------------------

if [[ "$COMPARTMENT_TYPE" == "3" ]]; then


  # agency managed vnet
  # Required variables
  LOCATION="southeastasia"  # Change to your desired Azure region

  # custom resource group - single resoruce group feature
  if [[ "$RESOURCE_GROUP_NAME" != "gcci-platform" ]]; then
    # If the resource group does not exist, attempt to create it
    az group create --name $RESOURCE_GROUP_NAME --location $LOCATION
    if [ $? -eq 0 ]; then
        echo "Resource group $RESOURCE_GROUP_NAME created successfully."
    else
        echo "ERROR: Failed to create resource group $RESOURCE_GROUP_NAME. Exiting."
        exit 1
    fi
  fi

  # Create the Virtual Network - project vnet
  az network vnet create \
    --name "$VNET_PROJECT_NAME" \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --location "$LOCATION" \
    --address-prefix "$GCCI_VNET_PROJECT_CIDR" \
    --tags Environment=$ENVIRONMENT Project=Project
  if [ $? -ne 0 ]; then
    echo -e "     "
    echo -e "\e[31m0-Network Project Vnet create failed. Exiting.\e[0m"
    exit 1
  else    
    echo "✅ Virtual Network '$VNET_PROJECT_NAME' created with address space $GCCI_VNET_PROJECT_CIDR"
  fi        

  # Create the Virtual Network - devops vnet
  az network vnet create \
    --name "$VNET_DEVOPS_NAME" \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --location "$LOCATION" \
    --address-prefix "$GCCI_VNET_DEVOPS_CIDR" \
    --tags Environment=$ENVIRONMENT Purpose=DevOps
  if [ $? -ne 0 ]; then
    echo -e "     "
    echo -e "\e[31m0-Network DevOps Vnet create failed. Exiting.\e[0m"
    exit 1
  else
    echo "✅ Virtual Network '$VNET_DEVOPS_NAME' created with address space $GCCI_VNET_DEVOPS_CIDR"
  fi   

fi


./import.sh 
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

if [[ "$LANDINGZONE_TYPE" == "application"  || "$LANDINGZONE_TYPE" == "1" ]]; then

  tfexe apply -path=$WORKING_DIR/templates/landingzone/configuration/1-landingzones/application/networking_spoke_project
  if [ $? -ne 0 ]; then
    echo -e "     "
    echo -e "\e[31mCreate 1-Landing Zone networking_spoke_project failed. Exiting.\e[0m"
    exit 1
  fi

  tfexe apply -path=$WORKING_DIR/templates/landingzone/configuration/1-landingzones/application/networking_spoke_devops
  if [ $? -ne 0 ]; then
    echo -e "     "
    echo -e "\e[31mCreate 1-Landing Zone networking_spoke_devops failed. Exiting.\e[0m"
    exit 1
  fi

  tfexe apply -path=$WORKING_DIR/templates/landingzone/configuration/1-landingzones/application/networking_peering_project_devops
  if [ $? -ne 0 ]; then
    echo -e "     "
    echo -e "\e[31mCreate 1-Landing Zone networking_peering_project_devops failed. Exiting.\e[0m"
    exit 1
  fi

else

  tfexe apply -path=$WORKING_DIR/templates/landingzone/configuration/1-landingzones/platform/networking_hub_internet_ingress
  if [ $? -ne 0 ]; then
    echo -e "     "
    echo -e "\e[31mCreate 1-Landing Zone networking_hub_internet_ingress failed. Exiting.\e[0m"
    exit 1
  fi

  tfexe apply -path=$WORKING_DIR/templates/landingzone/configuration/1-landingzones/platform/networking_hub_intranet_ingress
  if [ $? -ne 0 ]; then
    echo -e "     "
    echo -e "\e[31mCreate 1-Landing Zone networking_hub_intranet_ingress failed. Exiting.\e[0m"
    exit 1
  fi

  tfexe apply -path=$WORKING_DIR/templates/landingzone/configuration/1-landingzones/platform/networking_spoke_management
  if [ $? -ne 0 ]; then
    echo -e "     "
    echo -e "\e[31mCreate 1-Landing Zone networking_spoke_management failed. Exiting.\e[0m"
    exit 1
  fi

  tfexe apply -path=$WORKING_DIR/templates/landingzone/configuration/1-landingzones/platform/networking_peering
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
# ./../lib/deploy_azure_resources.sh <path_to_settings_yaml_file> <path_to_config_yaml_file> <landingzone_type>
# EXAMPLE: 
# ./../lib/deploy_azure_resources.sh "/tf/avm/scripts/config/settings.yaml" "/tf/avm/config/config.yaml" "1"
# ./../lib/deploy_azure_resources.sh "/tf/avm/scripts/config/settings_platform_landing_zone.yaml" "/tf/avm/config/config.yaml" "2"
#------------------------------------------------------------------------
echo "deploy azure resources - 2-solution accelerators"

cd "${WORKING_DIR}/scripts/bin"

./../lib/deploy_azure_resources.sh $SETTINGS_YAML_FILE_PATH $CONFIG_YAML_FILE_PATH $LANDINGZONE_TYPE

if [ $? -ne 0 ]; then
  echo -e "     "
  echo -e "\e[31mDeploy azure_resources failed. Exiting.\e[0m"
  exit 1
else
  echo -e "\e[32mall azure resources deployed successfully!\e[0m"  
fi





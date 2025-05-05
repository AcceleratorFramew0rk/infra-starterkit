#!/bin/bash

#------------------------------------------------------------------------
# USAGE:
# cd /tf/avm/scripts/bin # ** must run from this directory
# ./deploy.sh
#------------------------------------------------------------------------

# goto working directory
cd /tf/avm/scripts/bin

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





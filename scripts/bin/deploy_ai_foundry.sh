#!/bin/bash
#------------------------------------------------------------------------
# pre - prepare the environment
#------------------------------------------------------------------------

sudo chmod -R -f 777 /tf/avm/templates/landingzone/configuration/level0/gcci_platform/import.sh
sudo chmod -R -f 777 /tf/avm/templates/landingzone/configuration
sudo chmod -R -f 777 /tf/avm/scripts

tfexe generate-config -path=/tf/avm/scripts/bin
if [ $? -ne 0 ]; then
  echo -e "     "
  echo -e "\e[31mGenerate Config failed. Exiting.\e[0m"
  exit 1
fi

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
#------------------------------------------------------------------------

tfexe apply run-all -include=/tf/avm/AI_Foundry_LZ_single_resource_group.hcl
if [ $? -ne 0 ]; then
  echo -e "     "
  echo -e "\e[31mCreate 1-Landing Zone failed. Exiting.\e[0m"
  exit 1
fi

#------------------------------------------------------------------------
### 2. Solution Accelerators
### Note: ** storage account has to be deploy before AI Foundry Enterprise
#------------------------------------------------------------------------

tfexe apply run-all -include=/tf/avm/AI_Foundry_pattern_single_resource_group.hcl
if [ $? -ne 0 ]; then
  echo -e "     "
  echo -e "\e[31mCreate 2-Solution Accelerators failed. Exiting.\e[0m"
  exit 1
fi

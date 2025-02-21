#!/bin/bash

# keyvault - is the first resource to be deployed in the solution accelerators. 
cd /tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/keyvault
terraform-init-custom
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1
terraform plan 
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1
terraform apply
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1

# acr
cd /tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/acr
terraform-init-custom
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1
terraform plan 
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1
terraform apply
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1

# aks
cd /tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/aks_avm_ptn
terraform-init-custom
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1
terraform plan 
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1
terraform apply
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1

# mssql
cd /tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/mssql
terraform-init-custom
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1
terraform plan 
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1
terraform apply
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1


# storage account
cd /tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/storage_account
terraform-init-custom
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1
terraform plan 
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1
terraform apply
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1

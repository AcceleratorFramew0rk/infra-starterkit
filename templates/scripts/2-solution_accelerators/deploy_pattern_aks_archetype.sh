#!/bin/bash

# keyvault - is the first resource to be deployed in the solution accelerators. 
tfignite apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/keyvault
[ $? -ne 0 ] && echo -e "\e[31mTerraform apply failed. Exiting.\e[0m" && exit 1

# acr
tfignite apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/acr
[ $? -ne 0 ] && echo -e "\e[31mTerraform apply failed. Exiting.\e[0m" && exit 1

# aks
tfignite apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/aks_avm_ptn
[ $? -ne 0 ] && echo -e "\e[31mTerraform apply failed. Exiting.\e[0m" && exit 1

# mssql
tfignite apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/mssql
[ $? -ne 0 ] && echo -e "\e[31mTerraform apply failed. Exiting.\e[0m" && exit 1

# storage account
tfignite apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/storage_account
[ $? -ne 0 ] && echo -e "\e[31mTerraform apply failed. Exiting.\e[0m" && exit 1

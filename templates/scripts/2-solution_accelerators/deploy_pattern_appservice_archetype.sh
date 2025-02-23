#!/bin/bash

# keyvault
tfignite apply -path=cd /tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/keyvault
[ $? -ne 0 ] && echo -e "\e[31mTerraform apply failed. Exiting.\e[0m" && exit 1

# app service
tfignite apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/app_service
[ $? -ne 0 ] && echo -e "\e[31mTerraform apply failed. Exiting.\e[0m" && exit 1

# mssql
tfignite apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/mssql
[ $? -ne 0 ] && echo -e "\e[31mTerraform apply failed. Exiting.\e[0m" && exit 1

# # storage account
# tfignite apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/storage_account
# [ $? -ne 0 ] && echo -e "\e[31mTerraform apply failed. Exiting.\e[0m" && exit 1

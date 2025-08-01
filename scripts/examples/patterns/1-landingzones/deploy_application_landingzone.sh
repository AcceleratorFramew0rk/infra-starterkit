#!/bin/bash

# #------------------------------------------------------------------------
# # get configuration file path, resource group name, storage account name, subscription id, subscription name
# #------------------------------------------------------------------------
PREFIX=$(yq  -r '.prefix' /tf/avm/config/config.yaml)
RG_NAME="${PREFIX}-rg-launchpad"
STG_NAME=$(az storage account list --resource-group $RG_NAME --query "[?contains(name, '${PREFIX//-/}stgtfstate')].[name]" -o tsv 2>/dev/null | head -n 1)
if [[ -z "$STG_NAME" ]]; then
    echo "No storage account found matching the prefix."
    exit
else
    ACCOUNT_INFO=$(az account show 2> /dev/null)
    if [[ $? -ne 0 ]]; then
        echo "no subscription"
        exit
    fi
    SUB_ID=$(echo "$ACCOUNT_INFO" | jq ".id" -r)
    SUB_NAME=$(echo "$ACCOUNT_INFO" | jq ".name" -r)
    USER_NAME=$(echo "$ACCOUNT_INFO" | jq ".user.name" -r)
    SUBSCRIPTION_ID="${SUB_ID}" 
fi

echo "PREFIX: ${PREFIX}"
echo "Subscription Id: ${SUB_ID}"
echo "Subscription Name: ${SUB_NAME}"
echo "Storage Account Name: ${STG_NAME}"
echo "Resource Group Name: ${RG_NAME}"

#------------------------------------------------------------------------
# end get configuration file path, resource group name, storage account name, subscription id, subscription name
#------------------------------------------------------------------------

# spoke project 
cd /tf/avm/templates/landingzone/configuration/1-landingzones/application/networking_spoke_project

terraform init  -reconfigure \
-backend-config="resource_group_name=${RG_NAME}" \
-backend-config="storage_account_name=${STG_NAME}" \
-backend-config="container_name=1-landingzones" \
-backend-config="key=network-spoke-project.tfstate"

[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1

terraform plan \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"

[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1

terraform apply -auto-approve \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"

[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1

# spoke devops 
cd /tf/avm/templates/landingzone/configuration/1-landingzones/application/networking_spoke_devops

terraform init  -reconfigure \
-backend-config="resource_group_name=${RG_NAME}" \
-backend-config="storage_account_name=${STG_NAME}" \
-backend-config="container_name=1-landingzones" \
-backend-config="key=network-spoke-devops.tfstate"

[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1

terraform plan \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"

[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1

terraform apply -auto-approve \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"

[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1

# peering project-devops
cd /tf/avm/templates/landingzone/configuration/1-landingzones/application/networking_peering_project_devops

terraform init  -reconfigure \
-backend-config="resource_group_name=${RG_NAME}" \
-backend-config="storage_account_name=${STG_NAME}" \
-backend-config="container_name=1-landingzones" \
-backend-config="key=network-peering-project-devops.tfstate"

[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1

terraform plan \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"

[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1

terraform apply -auto-approve \
-var="storage_account_name=${STG_NAME}" \
-var="resource_group_name=${RG_NAME}"

[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1

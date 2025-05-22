#!/bin/bash

# -----------------------------------------------------------------------------------------
# USAGE:
# cd $(pwd)/starterkit
# ./cicd/scripts/deploy_0_launchpad.sh
# -----------------------------------------------------------------------------------------

# ** IMPORTANT: always start with top level path of starterkit
WORKING_DIR="$(pwd)"

echo "Working Directory: ${WORKING_DIR}"
# Echo the contents of ./config.yaml
echo "config.yaml content:"
# cat ./config.yaml
CONFIG_FILE="${WORKING_DIR}/templates/landingzone/configuration/0-launchpad/scripts/config.yaml"
cat "${WORKING_DIR}/templates/landingzone/configuration/0-launchpad/scripts/config.yaml"
PREFIX=$(yq -r '.prefix' ${CONFIG_FILE})
RG_NAME="${PREFIX}-rg-launchpad"
echo "Resource Group name: ${RG_NAME}"

# Try to get the storage account name
STG_NAME=$(az storage account list \
  --resource-group "$RG_NAME" \
  --query "[?contains(name, '${PREFIX//-/}stgtfstate')].[name]" \
  -o tsv 2>/dev/null | head -n 1)
if [ $? -ne 0 ]; then
    echo "Failed to import. Error in command [az storage account list]. Exiting."
    exit 1
fi

# Check if the command failed or STG_NAME is empty
if [ $? -ne 0 ] || [ -z "$STG_NAME" ]; then

  echo "No existing storage account: ${STG_NAME}"

  # ** IMPORTANT: cd to the directory where the script is located
  cd "${WORKING_DIR}/templates/landingzone/configuration/0-launchpad/launchpad_agency_managed_vnet"
  echo "Start importing vnet tfstate"   
  echo "$(pwd)"
  echo "Running ..."         
  echo "./scripts/import.sh ${WORKING_DIR}"         
  ./scripts/import.sh "${WORKING_DIR}"
  if [ $? -ne 0 ]; then
    echo "Failed to import vnet tfstate. Exiting."
    exit 1
  fi

else

  echo "Storage Account name: ${STG_NAME}"
  echo "Using existing Resource group and storage account"
  echo "Start updating tfstate config info"    
  # ** IMPORTANT: cd to the directory where the script is located   
  cd "${WORKING_DIR}/templates/landingzone/configuration/0-launchpad/launchpad_agency_managed_vnet"
  echo "Start importing vnet tfstate"   
  echo "$(pwd)"
  echo "Running ..."         
  echo "./scripts/update_remote_state.sh ${WORKING_DIR}"    
  ./scripts/update_remote_state.sh "${WORKING_DIR}"
  if [ $? -ne 0 ]; then
    echo "Failed to update remote state. Exiting."
    exit 1
  fi

fi
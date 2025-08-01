#!/bin/bash

# -----------------------------------------------------------------------------------------
# USAGE:
# cd $(pwd)/starterkit
# ./cicd/scripts/bin/deploy_0_launchpad.sh
# -----------------------------------------------------------------------------------------

# ** IMPORTANT: always start with top level path of starterkit


# must start with the top level path of starterkit
WORKING_DIRECTORY=$(pwd) # pwd should always be ./starterkit or $(pwd)/starterkit

# Echo the contents of ./config.yaml
echo "config.yaml content:"
# cat ./config.yaml
cat ./config/config.yaml
PREFIX=$(yq -r '.prefix' './config.yaml')
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
  cd "${WORKING_DIRECTORY}/scripts/bin"
  echo "Start importing vnet tfstate"  
  ./import.sh
  if [ $? -ne 0 ]; then
    echo "Failed to import vnet tfstate. Exiting."
    exit 1
  fi

else

  echo "Storage Account name: ${STG_NAME}"
  echo "Using existing Resource group and storage account"
  echo "Start updating tfstate config info"    
  # # ** IMPORTANT: cd to the directory where the script is located   
  cd "${WORKING_DIRECTORY}/scripts/bin"
  ./update_remote_state.sh $WORKING_DIRECTORY
  if [ $? -ne 0 ]; then
    echo "Failed to Update Remote State vnet tfstate. Exiting."
    exit 1
  fi

fi
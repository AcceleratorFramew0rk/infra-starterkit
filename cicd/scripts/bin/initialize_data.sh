#!/bin/bash

# -----------------------------------------------------------------------------------------
# USAGE:
# cd $(pwd)/starterkit
# ./cicd/scripts/bin/initialize_data.sh "starterkit" "${{ github.event.inputs.config_yaml }}" "${{ github.event.inputs.solution_accelerator }}"
# -----------------------------------------------------------------------------------------

STARTERKIT_FOLDER=$1
CONFIG_YAML=$2
SOLUTION_ACCELERATOR=$3


# get config.yaml from input and write to file
WORKING_DIRECTORY=$(pwd)
echo $WORKING_DIRECTORY
decoded_config_yaml=$(echo "${CONFIG_YAML}" | base64 --decode)
echo "$decoded_config_yaml" > "${WORKING_DIRECTORY}/${STARTERKIT_FOLDER}/templates/landingzone/configuration/0-launchpad/scripts/config.yaml"
echo "$decoded_config_yaml" > "${WORKING_DIRECTORY}/config.yaml"

# ** IMPORTANT: ensure config.yaml file is available as the path is hardcoded in the terraform code

# get solution accelerator from input and write to file
decoded_solution_accelerator=$(echo "${SOLUTION_ACCELERATOR}" | base64 --decode)
echo $decoded_solution_accelerator

# get solution accelerator selectedServices and selectedServicesConfig from input 
selectedServices=$(echo "$decoded_solution_accelerator" | jq -r '.[0].selectedServices')
# Convert to JSON object
validSelectedServices=$(echo "$selectedServices" | jq '.')

# Convert to array format
selectedServices=$(echo "$validSelectedServices" | jq '[to_entries[] | {(.key): .value}]')
echo "selectedServices:"
echo $selectedServices
selectedServicesConfig=$(echo "$decoded_solution_accelerator" | jq -r '.[1].selectedServicesConfig')
echo "selectedServicesConfig:"
echo $selectedServicesConfig
# write to files
echo "$selectedServices" > "${WORKING_DIRECTORY}/${STARTERKIT_FOLDER}/cicd/scripts/config/selectedServices.json"
echo "$selectedServicesConfig" > "${WORKING_DIRECTORY}/${STARTERKIT_FOLDER}/cicd/scripts/config/selectedServicesConfig.json"

# generate config.yaml
sudo chmod -R -f 777 "${WORKING_DIRECTORY}/starterkit/cicd/scripts/"

# Read YAML file and extract "prefix"
PREFIX=$(yq -r '.prefix' './config.yaml')

SUBSCRIPTION_ID=$(yq -r '.subscription_id' './config.yaml')
ENVIRONMENT="${{ github.event.inputs.environment }}" 
LOCATION=southeastasia 
VNET_PROJECT_NAME=gcci-vnet-project 
VNET_DEVOPS_NAME=gcci-vnet-devops
echo $PREFIX
echo $SUBSCRIPTION_ID
echo $ENVIRONMENT
echo $LOCATION
echo $VNET_PROJECT_NAME
echo $VNET_DEVOPS_NAME

cd ./starterkit
"${WORKING_DIRECTORY}/${STARTERKIT_FOLDER}/cicd/scripts/bin/generate_config.sh" $PREFIX $SUBSCRIPTION_ID $ENVIRONMENT $LOCATION $VNET_PROJECT_NAME $VNET_DEVOPS_NAME

# # copy final config.yaml to destination
cp "${WORKING_DIRECTORY}/${STARTERKIT_FOLDER}/cicd/scripts/config/output_config.yaml" "${WORKING_DIRECTORY}/config.yaml"
cp "${WORKING_DIRECTORY}/${STARTERKIT_FOLDER}/cicd/scripts/config/output_config.yaml" "${WORKING_DIRECTORY}/${STARTERKIT_FOLDER}/templates/landingzone/configuration/0-launchpad/scripts/config.yaml"

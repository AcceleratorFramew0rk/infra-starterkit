#!/bin/bash

# Function to prompt for user input with default value support
prompt_for_input() {
  local prompt_message=$1
  local default_value=$2
  local user_input

  # Read input from the user
  read -rp "$prompt_message [$default_value]: " user_input

  # If input is empty, use the default value
  echo "${user_input:-$default_value}"
}

# Prompt for PREFIX, ensuring it is not empty
while true; do
  read -rp "Enter the PREFIX (required): " PREFIX
  if [[ -n "$PREFIX" ]]; then
    break
  else
    echo "PREFIX must not be empty. Please try again."
  fi
done

# Prompt for VNET Project Name with a default value
RESOURCE_GROUP_NAME=$(prompt_for_input "Enter the Resource Group Name" "gcci-platform")

# Prompt for VNET Project Name with a default value
ENVIRONMENT=$(prompt_for_input "Enter the ENVIRONMENT (dev, sit, uat, prd)" "dev")

# Prompt for settings.yaml path with a default value
LANDINGZONE_TYPE=$(prompt_for_input "Enter the Landing Zone Type (1: application or 2: platform)" "1")

# initialize VNET variables for application type = 1
VNET_PROJECT_NAME=""
GCCI_VNET_PROJECT_CIDR=""
VNET_DEVOPS_NAME=""
GCCI_VNET_DEVOPS_CIDR=""

if [[ "$LANDINGZONE_TYPE" == "1" || "$LANDINGZONE_TYPE" == "application" ]]; then
  # Prompt for VNET Project Name with a default value
  VNET_PROJECT_NAME=$(prompt_for_input "Enter the VNET Project Name" "gcci-vnet-project")
  GCCI_VNET_PROJECT_CIDR=$(prompt_for_input "Enter the Agency Managed VNET Project CIDR (Enter 'na' if not using Agency Managed VNET)" "192.168.0.0/23")

  # Prompt for VNET DevOps Name with a default value
  VNET_DEVOPS_NAME=$(prompt_for_input "Enter the VNET DevOps Name" "gcci-vnet-devops")
  GCCI_VNET_DEVOPS_CIDR=$(prompt_for_input "Enter the Agency Managed VNET DevOps CIDR (Enter 'na' if not using Agency Managed VNET)" "192.168.10.0/24")
fi

if [[ "$LANDINGZONE_TYPE" == "1" || "$LANDINGZONE_TYPE" == "application" ]]; then
  # Prompt for settings.yaml path with a default value
  SETTINGS_YAML_FILE_PATH=$(prompt_for_input "Enter the settings.yaml path" "/tf/avm/scripts/config/settings.yaml")
else
  # Prompt for settings.yaml path with a default value
  SETTINGS_YAML_FILE_PATH=$(prompt_for_input "Enter the settings.yaml path" "/tf/avm/scripts/config/settings_platform_landing_zone.yaml")
fi

# Output the collected inputs
echo "Configuration:"
echo "PREFIX: $PREFIX"
echo "RESOURCE GROUP NAME: $RESOURCE_GROUP_NAME"
echo "ENVIRONMENT: $ENVIRONMENT"
echo "LANDINGZONE TYPE: $LANDINGZONE_TYPE"
if [[ "$LANDINGZONE_TYPE" == "1" || "$LANDINGZONE_TYPE" == "application" ]]; then
  echo "VNET PROJECT NAME: $VNET_PROJECT_NAME"
  echo "VNET DEVOPS NAME: $VNET_DEVOPS_NAME"
fi
echo "SETTINGS YAML FILE PATH: $SETTINGS_YAML_FILE_PATH"
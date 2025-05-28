
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

# Prompt for Resource Group Name, ensuring it is not empty
while true; do
  # Prompt for Resource Group Name with a default value
  RESOURCE_GROUP=$(prompt_for_input "Enter the Resource Group Name" "sub-agency-law")
  if [[ -n "$RESOURCE_GROUP" ]]; then
    break
  else
    echo "Resource Group Name must not be empty. Please try again."
  fi
done

# Prompt for Log Analytics Workspace Name, ensuring it is not empty
while true; do
  # Prompt for Log Analytics Workspace Name with a default value
  WORKSPACE_NAME=$(prompt_for_input "Enter the Log Analytics Workspace Name" "sub-agency-workspace")
  if [[ -n "$WORKSPACE_NAME" ]]; then
    break
  else
    echo "Log Analytics Workspace Name must not be empty. Please try again."
  fi
done

# Other Variables
LOCATION="southeastasia"

# Create the Resource Group
az group create \
  --name $RESOURCE_GROUP \
  --location $LOCATION

# Create the Log Analytics Workspace
az monitor log-analytics workspace create \
  --resource-group $RESOURCE_GROUP \
  --workspace-name $WORKSPACE_NAME \
  --location $LOCATION

#!/bin/bash

# input.yaml - variables yaml file for prefix, environment
# settings.yaml - what services to deploy for the landing zone

# USAGE: 
# cd to the bin directory, execute the script with the following parameters
# ./generate_config.sh <prefix> <subscription_id> <environment> <location> <vnet_project_name> <vnet_devops_name> "<setting_file_path>"

#------------------------------------------------------------------------
# functions
#------------------------------------------------------------------------
get_vnet_cidr() {
  local resourcegroup=$1
  local vnetname=$2

  # Query the CIDR (address prefixes) of the virtual network
  vnet_cidr=$(az network vnet show \
    --resource-group "$resourcegroup" \
    --name "$vnetname" \
    --query "addressSpace.addressPrefixes[0]" \
    --output tsv)

  # Output the retrieved CIDR
  echo "$vnet_cidr"
}
#------------------------------------------------------------------------
# end functions
#------------------------------------------------------------------------

#------------------------------------------------------------------------
# prepare the environment
#------------------------------------------------------------------------

PREFIX=$1
SUBSCRIPTION_ID=$2
ENVIRONMENT=${3:-dev} # default value is dev if empty
LOCATION=${4:-southeastasia} # default value if empty - "southeastasia"
VNET_PROJECT_NAME=${5:-gcci-vnet-project}  # Default to "gcci-vnet-project" if empty
VNET_DEVOPS_NAME=${6:-gcci-vnet-devops}  # Default to "gcci-vnet-devops" if empty
# SOLUTION_ACCELERATOR_CONFIG=$7

# Prompt for settings.yaml path with a default value
LANDINGZONE_TYPE="1"


# Additional installation steps can go here
echo "Running installation with the above configuration..."

export ARM_SUBSCRIPTION_ID="${SUBSCRIPTION_ID}"

# Variables for the resource group
RESOURCE_GROUP="GCCI-Platform"
# Variables for GCCI Project VNet and DevOps VNet CIDR
GCCI_VNET_PROJECT_CIDR=$(get_vnet_cidr "$RESOURCE_GROUP" "$VNET_PROJECT_NAME")
GCCI_VNET_DEVOPS_CIDR=$(get_vnet_cidr "$RESOURCE_GROUP" "$VNET_DEVOPS_NAME")

# Output the collected inputs
echo "Configuration:"
echo "PREFIX: $PREFIX"
echo "ENVIRONMENT: $ENVIRONMENT"
echo "SUBSCRIPTION_ID: $SUBSCRIPTION_ID"
echo "VNET PROJECT NAME: $VNET_PROJECT_NAME"
echo "VNET DEVOPS NAME: $VNET_DEVOPS_NAME"
echo "LANDINGZONE TYPE: $LANDINGZONE_TYPE"
echo "The CIDR of the GCCI Project Virtual Network is: $GCCI_VNET_PROJECT_CIDR"
echo "The CIDR of the GCCI DevOps Virtual Network is: $GCCI_VNET_DEVOPS_CIDR"

# Additional installation steps can go here


#------------------------------------------------------------------------
# end get configuration file path, resource group name, storage account name, subscription id, subscription name
#------------------------------------------------------------------------

# Output the variables to a text file (input.yaml)
INPUT_CONFIG=$(cat <<EOF
subscription_id: "${SUBSCRIPTION_ID}"
prefix: "${PREFIX}"
is_prefix: false
is_single_resource_group: false
environment: "${ENVIRONMENT}"
vnets:
  hub_ingress_internet: 
    name:   
    cidr: 
  hub_egress_internet:  
    name:   
    cidr: 
  hub_ingress_intranet:  
    name:  
    cidr: 
  hub_egress_intranet:  
    name:    
    cidr: 
  management:  
    name:     
    cidr: 
  project:  
    name: "$VNET_PROJECT_NAME"
    cidr: "$GCCI_VNET_PROJECT_CIDR"
  devops:  
    name: "$VNET_DEVOPS_NAME"  
    cidr: "$GCCI_VNET_DEVOPS_CIDR"  
EOF
)

echo "Input Config: $INPUT_CONFIG"

    # input_yaml_file_path = './../config/input.yaml' # '/tf/avm/scripts/input.yaml'
    # solution_accelerator_yaml_file_path =  sys.argv[1] # '/tf/avm/scripts/settings.yaml'

echo "$INPUT_CONFIG" > './../config/input.yaml'

SOLUTION_ACCELERATOR_CONFIG=$(cat ./../config/selectedServices.json)

# Convert to YAML and write to config.yaml
cat <<EOF > './../config/settings.yaml'
devops:
  ContainerInstance: true
project:
EOF
echo "$SOLUTION_ACCELERATOR_CONFIG" | jq -r '
    map(to_entries[]) | 
    map("  " + .key + ": " + (.value | tostring)) | 
    join("\n")' >> './../config/settings.yaml'



# "Usage: python3 render_config.py <settings_yaml_file_path>
python3 ./../lib/render_config.py 
if [ $? -ne 0 ]; then
  echo -e "\e[31mrender_config execution failed. Exiting.\e[0m"
  exit 1
fi


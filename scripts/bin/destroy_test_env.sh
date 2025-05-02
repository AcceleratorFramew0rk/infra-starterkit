#!/bin/bash



# Login to Azure if not already logged in
az account show > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "You are not logged in. Logging in..."
  exit 1
fi


# -------------------------------------------------------------------------------------------------
# This script deletes all resource groups containing '-solution-accelerators-' in their names.
# -------------------------------------------------------------------------------------------------


# Fetch and loop through all matching resource groups
echo "Finding resource groups containing '-solution-accelerators-'..."

for rg in $(az group list --query "[?contains(name, '-solution-accelerators-')].name" -o tsv); do
  echo "Deleting resource group: $rg"
  az group delete --name "$rg" --yes
done

echo "Deletion commands issued for all matching resource groups."


# -------------------------------------------------------------------------------------------------
# This script deletes all VNet peerings between two VNets in different resource groups.
# -------------------------------------------------------------------------------------------------


# Variables
RESOURCE_GROUP_PROJECT="gcci-platform"
RESOURCE_GROUP_DEVOPS="gcci-platform"

VNET_PROJECT="gcci-vnet-project"
VNET_DEVOPS="gcci-vnet-devops"

# Get peering names
PEERING_FROM_PROJECT_TO_DEVOPS=$(az network vnet peering list \
  --resource-group "$RESOURCE_GROUP_PROJECT" \
  --vnet-name "$VNET_PROJECT" \
  --query "[?remoteVirtualNetwork.id | contains(@, '$VNET_DEVOPS')].name" \
  -o tsv)

PEERING_FROM_DEVOPS_TO_PROJECT=$(az network vnet peering list \
  --resource-group "$RESOURCE_GROUP_DEVOPS" \
  --vnet-name "$VNET_DEVOPS" \
  --query "[?remoteVirtualNetwork.id | contains(@, '$VNET_PROJECT')].name" \
  -o tsv)

# Delete peerings
if [ -n "$PEERING_FROM_PROJECT_TO_DEVOPS" ]; then
  echo "Deleting peering '$PEERING_FROM_PROJECT_TO_DEVOPS' from $VNET_PROJECT to $VNET_DEVOPS..."
  az network vnet peering delete \
    --name "$PEERING_FROM_PROJECT_TO_DEVOPS" \
    --resource-group "$RESOURCE_GROUP_PROJECT" \
    --vnet-name "$VNET_PROJECT"
else
  echo "No peering found from $VNET_PROJECT to $VNET_DEVOPS."
fi

if [ -n "$PEERING_FROM_DEVOPS_TO_PROJECT" ]; then
  echo "Deleting peering '$PEERING_FROM_DEVOPS_TO_PROJECT' from $VNET_DEVOPS to $VNET_PROJECT..."
  az network vnet peering delete \
    --name "$PEERING_FROM_DEVOPS_TO_PROJECT" \
    --resource-group "$RESOURCE_GROUP_DEVOPS" \
    --vnet-name "$VNET_DEVOPS"
else
  echo "No peering found from $VNET_DEVOPS to $VNET_PROJECT."
fi

echo "Peering removal completed."


# -------------------------------------------------------------------------------------------------
# This script deletes all subnets under the specified VNets in the given resource groups.
# -------------------------------------------------------------------------------------------------

# Variables
RESOURCE_GROUP_PROJECT="gcci-platform"
RESOURCE_GROUP_DEVOPS="gcci-platform"

VNET_PROJECT="gcci-vnet-project"
VNET_DEVOPS="gcci-vnet-devops"

# Function to delete all subnets under a VNet
delete_subnets() {
  local resource_group=$1
  local vnet_name=$2

  echo "Fetching subnets under VNet: $vnet_name in Resource Group: $resource_group"

  subnets=$(az network vnet subnet list \
    --resource-group "$resource_group" \
    --vnet-name "$vnet_name" \
    --query "[].name" \
    -o tsv)

  if [ -z "$subnets" ]; then
    echo "No subnets found in VNet $vnet_name."
    return
  fi

  for subnet in $subnets; do
    echo "Deleting subnet: $subnet from VNet: $vnet_name"
    az network vnet subnet delete \
      --name "$subnet" \
      --resource-group "$resource_group" \
      --vnet-name "$vnet_name"
  done

  echo "All subnets deleted from VNet: $vnet_name."
}

# Delete subnets from both VNets
delete_subnets "$RESOURCE_GROUP_PROJECT" "$VNET_PROJECT"
delete_subnets "$RESOURCE_GROUP_DEVOPS" "$VNET_DEVOPS"

echo "Subnet removal completed for both VNets."


# -------------------------------------------------------------------------------------------------
# This script deletes all resource groups containing '-network-spoke-' in their names.
# -------------------------------------------------------------------------------------------------

# Fetch all resource groups that match the pattern "-network-spoke-"
resource_groups=$(az group list --query "[?contains(name, '-network-spoke-')].name" -o tsv)

if [ -z "$resource_groups" ]; then
  echo "No resource groups found matching '-network-spoke-'."
  exit 0
fi

# Loop through and delete each matching resource group
for rg in $resource_groups; do
  echo "Deleting resource group: $rg ..."
  az group delete --name "$rg" --yes 
done

echo "Deletion commands issued for all matching resource groups."
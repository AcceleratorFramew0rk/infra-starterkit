# Variables
LOCATION="southeastasia"
RESOURCE_GROUP="sub-agency-law"
WORKSPACE_NAME="sub-agency-workspace"

# Create the Resource Group
az group create \
  --name $RESOURCE_GROUP \
  --location $LOCATION

# Create the Log Analytics Workspace
az monitor log-analytics workspace create \
  --resource-group $RESOURCE_GROUP \
  --workspace-name $WORKSPACE_NAME \
  --location $LOCATION

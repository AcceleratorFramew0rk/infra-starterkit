# Navigate to the working directory where the Terraform configuration files are located
cd /tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/stream_analytics

# Run the Custom Terraform initialization script "terraform-init-custom" at location "/usr/local/bin" to set up the backend and providers
terraform-init-custom

# Generate an execution plan to preview the changes Terraform will make
terraform plan

# Apply the Terraform configuration and automatically approve changes without prompting for confirmation
terraform apply -auto-approve


# -------------------------------------------------------------------------
# Approved stream analytics managed private endpoint via Azure CLI
# -------------------------------------------------------------------------

<!-- az network private-endpoint-connection approve -g "${RESOURCE_GROUP_NAME}" -n ${CONNECTION_NAME}  --resource-name "${RESOURCE_NAME}" --type "${TYPE}" --description "Approving private endpoint for Stream Analytics" -->

# Sample Command
# az network private-endpoint-connection approve -g MyResourceGroup -n MyPrivateEndpoint --resource-name MySA --type Microsoft.Storage/storageAccounts --description "Approved"

PREFIX=$(yq  -r '.prefix' /tf/avm/templates/landingzone/configuration/0-launchpad/scripts/config.yaml)

# iot hub
# --------------------------------

TYPE="Microsoft.Devices/IotHubs"
RESOURCE_GROUP_NAME=$(az group list --query "[?ends_with(name, 'solution-accelerators-iothub')].[name] | [0]"   -o tsv)
RESOURCE_NAME=$(az resource list   --resource-group  "${RESOURCE_GROUP_NAME}"   --resource-type "${TYPE}"  --query "[0].name"   --output tsv)
CONNECTION_NAME=$(az network private-endpoint-connection list -g "${RESOURCE_GROUP_NAME}" -n "${RESOURCE_NAME}" --type "${TYPE}" --query "[0].name" -o tsv)
echo $PREFIX
echo $RESOURCE_GROUP_NAME
echo $RESOURCE_NAME
echo $CONNECTION_NAME

az network private-endpoint-connection approve -g "${RESOURCE_GROUP_NAME}" -n ${CONNECTION_NAME}  --resource-name "${RESOURCE_NAME}" --type "${TYPE}" --description "Approving private endpoint for Stream Analytics"


# event hub
# --------------------------------

TYPE="Microsoft.EventHub/namespaces"
RESOURCE_GROUP_NAME=$(az group list --query "[?ends_with(name, 'solution-accelerators-eventhub')].[name] | [0]"   -o tsv)
RESOURCE_NAME=$(az resource list   --resource-group  "${RESOURCE_GROUP_NAME}"   --resource-type "${TYPE}"   --query "[0].name"   --output tsv)
CONNECTION_NAME=$(az network private-endpoint-connection list -g "${RESOURCE_GROUP_NAME}" -n "${RESOURCE_NAME}" --type "${TYPE}" --query "[0].name" -o tsv)
echo $PREFIX
echo $RESOURCE_GROUP_NAME
echo $RESOURCE_NAME
echo $CONNECTION_NAME

az network private-endpoint-connection approve -g "${RESOURCE_GROUP_NAME}" -n ${CONNECTION_NAME}  --resource-name "${RESOURCE_NAME}" --type "${TYPE}" --description "Approving private endpoint for Stream Analytics"


# data explorer
# --------------------------------

TYPE="Microsoft.Kusto/clusters"
RESOURCE_GROUP_NAME=$(az group list --query "[?ends_with(name, 'solution-accelerators-dataexplorer')].[name] | [0]"   -o tsv)
RESOURCE_NAME=$(az resource list   --resource-group  "${RESOURCE_GROUP_NAME}"   --resource-type "${TYPE}"   --query "[0].name"   --output tsv)
CONNECTION_NAME=$(az network private-endpoint-connection list -g "${RESOURCE_GROUP_NAME}" -n "${RESOURCE_NAME}" --type "${TYPE}" --query "[0].name" -o tsv)

echo $PREFIX
echo $RESOURCE_GROUP_NAME
echo $RESOURCE_NAME
echo $CONNECTION_NAME

az network private-endpoint-connection approve -g "${RESOURCE_GROUP_NAME}" -n ${CONNECTION_NAME}  --resource-name "${RESOURCE_NAME}" --type "${TYPE}" --description "Approving private endpoint for Stream Analytics"



# sql server
# --------------------------------

TYPE="Microsoft.Sql/servers"
RESOURCE_GROUP_NAME=$(az group list --query "[?ends_with(name, 'solution-accelerators-mssql')].[name] | [0]"   -o tsv)
RESOURCE_NAME=$(az resource list   --resource-group  "${RESOURCE_GROUP_NAME}"   --resource-type Microsoft.Sql/servers   --query "[0].name"   --output tsv)
CONNECTION_NAME=$(az network private-endpoint-connection list   -g "${RESOURCE_GROUP_NAME}"   -n "${RESOURCE_NAME}"   --type  "${TYPE}"    --query "[?starts_with(name, 'saprivateendpoint')].[name] | [0]"   -o tsv)

echo $PREFIX
echo $RESOURCE_GROUP_NAME
echo $RESOURCE_NAME
echo $CONNECTION_NAME

az network private-endpoint-connection approve -g "${RESOURCE_GROUP_NAME}" -n ${CONNECTION_NAME}  --resource-name "${RESOURCE_NAME}" --type "${TYPE}" --description "Approving private endpoint for Stream Analytics"


# storage account
# --------------------------------

TYPE="Microsoft.Storage/storageAccounts"
RESOURCE_GROUP_NAME=$(az group list --query "[?ends_with(name, 'solution-accelerators-streamanalytics')].[name] | [0]"   -o tsv)
RESOURCE_NAME=$(az resource list  --resource-group $RESOURCE_GROUP_NAME  --resource-type "${TYPE}"  --query "[0].name"  --output tsv)
CONNECTION_NAME=$(az network private-endpoint-connection list -g "${RESOURCE_GROUP_NAME}" -n $RESOURCE_NAME --type "${TYPE}"  --query "[?starts_with(name, '$RESOURCE_NAME')].[name] | [0]" -o tsv)

echo $PREFIX
echo $RESOURCE_GROUP_NAME
echo $RESOURCE_NAME
echo $CONNECTION_NAME

az network private-endpoint-connection approve -g "${RESOURCE_GROUP_NAME}" -n ${CONNECTION_NAME}  --resource-name "${RESOURCE_NAME}" --type "${TYPE}" --description "Approving private endpoint for Stream Analytics"

# -------------------------------------------------------------------------
# End Approved via Azure CLI
# -------------------------------------------------------------------------

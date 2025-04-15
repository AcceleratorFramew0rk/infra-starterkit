# create bastion host and vm - linux
# --------------------------------------------------------------

```bash

# === Variables ===
LOCATION="southeastasia"
RESOURCE_GROUP="devops-rg-enterpriserunner"
VNET_NAME="devops-vnet-starter"
ADDRESS_PREFIX="192.168.0.0/23"
BASTION_SUBNET_PREFIX="192.168.0.0/26"
VM_SUBNET_NAME="VmSubnet"
VM_SUBNET_PREFIX="192.168.1.0/27"
PUBLIC_IP_NAME="vmBastionPIP"
BASTION_NAME="vmBastionHost"
VM_NAME="vmsk5e10w"
VM_ADMIN_USER="azureuser"
VM_IMAGE="Canonical:0001-com-ubuntu-server-focal:20_04-lts-gen2:latest" # "Ubuntu2204"
VM_SIZE="Standard_D4s_v3"

# === 1. Create Resource Group ===
az group create \
  --name $RESOURCE_GROUP \
  --location $LOCATION

# === 2. Create VNet with AzureBastionSubnet ===
az network vnet create \
  --resource-group $RESOURCE_GROUP \
  --name $VNET_NAME \
  --location $LOCATION \
  --address-prefix $ADDRESS_PREFIX \
  --subnet-name AzureBastionSubnet \
  --subnet-prefix $BASTION_SUBNET_PREFIX

# === 3. Add Subnet for VM ===
az network vnet subnet create \
  --resource-group $RESOURCE_GROUP \
  --vnet-name $VNET_NAME \
  --name $VM_SUBNET_NAME \
  --address-prefix $VM_SUBNET_PREFIX

# === 4. Create Public IP for Bastion ===
az network public-ip create \
  --resource-group $RESOURCE_GROUP \
  --name $PUBLIC_IP_NAME \
  --location $LOCATION \
  --sku Standard \
  --allocation-method Static

# === 5. Create Bastion Host ===
az network bastion create \
  --name $BASTION_NAME \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --vnet-name $VNET_NAME \
  --public-ip-address $PUBLIC_IP_NAME

# === 6. Create Network Interface for VM ===
az network nic create \
  --resource-group $RESOURCE_GROUP \
  --name ${VM_NAME}NIC \
  --vnet-name $VNET_NAME \
  --subnet $VM_SUBNET_NAME

# # === 7. Create Linux VM ===
az vm create \
  --resource-group $RESOURCE_GROUP \
  --name $VM_NAME \
  --nics ${VM_NAME}NIC \
  --image $VM_IMAGE \
  --size $VM_SIZE \
  --admin-username $VM_ADMIN_USER \
  --generate-ssh-keys \
  --no-wait

# copy the cert out 
# cd /home/vscode/.ssh
# cp *  /tf/avm/cicd/cert


# === 8. Create container instance with SDE image

SUB_ID="/subscriptions/0b5b13b8-0ad7-4552-936f-8fae87e0633f"

az container create \
  --name "aci-runner01" \
  --resource-group $RESOURCE_GROUP \
  --image acceleratorframew0rk/gccstarterkit-avm-sde:0.3  \
  --assign-identity --scope $SUB_ID \
  --cpu 4 \
  --memory 16 \
  --command-line '"/bin/sh" "-c" "while sleep 1000; do :; done"'

```

# continue with starter kit.


# Deploy the starter kit
## Login to Azure
# --------------------------------------------------------------
```bash
az login --tenant xxxxxxxx-xxxxxx-xxxx-xxxx-xxxxxxxxxxxx # azure tenant id

az account set --subscription xxxxxxxx-xxxxxx-xxxx-xxxx-xxxxxxxxxxxx # subscription id

az account show # to show the current login account

SUBSCRIPTION_ID="xxxxxxxx-xxxxxx-xxxx-xxxx-xxxxxxxxxxxx"
export ARM_SUBSCRIPTION_ID="${SUBSCRIPTION_ID}"

# ensure min "execute" right to script to avoid permission issue
sudo chmod -R -f 777 /tf/avm/templates/landingzone/configuration/level0/gcci_platform/import.sh
sudo chmod -R -f 777 /tf/avm/templates/landingzone/configuration

# To sign in, use a web browser to open the page 
# https://microsoft.com/devicelogin 

# and enter the code XXXXXXXXXXX to authenticate.

```

# access to the container instance
# --------------------------------------------------------------
```bash

az container exec \
  --resource-group $RESOURCE_GROUP \
  --name "aci-runner01" \
  --exec-command "/bin/zsh"


git clone https://github.com/AcceleratorFramew0rk/infra-starterkit .

sudo chmod -R -f 777 /tf/avm/templates/landingzone/configuration/level0/gcci_platform/import.sh
sudo chmod -R -f 777 /tf/avm/templates/landingzone/configuration

```


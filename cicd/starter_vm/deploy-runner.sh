#!/bin/bash

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
VM_NAME="vmstarterkitt5e"
VM_ADMIN_USER="azureuser"
VM_IMAGE="Canonical:0001-com-ubuntu-server-focal:20_04-lts-gen2:latest" # "Ubuntu2204"
VM_SIZE="Standard_B1s"

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

# === 7. Create Linux VM ===
az vm create \
  --resource-group $RESOURCE_GROUP \
  --name $VM_NAME \
  --nics ${VM_NAME}NIC \
  --image $VM_IMAGE \
  --size $VM_SIZE \
  --admin-username $VM_ADMIN_USER \
  --generate-ssh-keys \
  --no-wait


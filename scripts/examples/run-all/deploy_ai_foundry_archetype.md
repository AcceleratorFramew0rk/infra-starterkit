# AI Foundry Archetype

# Prerequisites

In order to start deploying your landing zones, you need an Azure subscription (Trial, MSDN, etc.) and you need to install the following components on your machine:
- Visual Studio Code
- Docker Desktop.
- Git
Once installed, open Visual Studio Code and install "Remote Development" extension

## Cloning the starter repository

- Download the repo as a zip file.
- Open working folder with Visual Studio Code (Note: Reopen in container when prompt in VS Code)
- (if required) Install VS Code Extension - Dev Containers
- Add a zsh terminal from VS Code

# Deploy the starter kit
## Login to Azure

```bash
az login --tenant xxxxxxxx-xxxxxx-xxxx-xxxx-xxxxxxxxxxxx # azure tenant id

az account set --subscription xxxxxxxx-xxxxxx-xxxx-xxxx-xxxxxxxxxxxx # subscription id

az account show # to show the current login account

SUBSCRIPTION_ID="xxxxxxxx-xxxxxx-xxxx-xxxx-xxxxxxxxxxxx"
export ARM_SUBSCRIPTION_ID="${SUBSCRIPTION_ID}"
```


## Step 0 - ** OPTIONAL (for non-gcc environment only)
** IMPORTANT: if required, modify config.yaml file to determine the vnets name and cidr ranage you want to deploy. 

```bash
cd /tf/avm/templates/0-setup_gcc_dev_env

terraform init -reconfigure
terraform plan
terraform apply -auto-approve
```

## 1. Launchpad - create launchpad storage account and containers

- set prefix and configuration
- modify /tf/avm/templates/landingzone/configuration/0-launchpad/scripts/config.yaml according to your vnet and subnet requirements

```bash
sudo chmod -R -f 777 /tf/avm/templates/landingzone/configuration/level0/gcci_platform/import.sh
sudo chmod -R -f 777 /tf/avm/templates/landingzone/configuration

cd /tf/avm/templates/landingzone/configuration/0-launchpad/launchpad

./scripts/import.sh

```

## 2. Infra and Application Landing zone and networking

```bash

tfexe apply run-all -include=/tf/avm/scripts/examples/AI_Foundry_LZ.hcl

```

### 3. Solution Accelerators

```bash

tfexe apply run-all -include=/tf/avm/scripts/examples/AI_Foundry_pattern.hcl

```


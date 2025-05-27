# Deploy archetype using tfexe apply run-all -include=<path of [pattern].hcl file>

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

sudo chmod -R -f 777 /tf/avm/templates/landingzone/configuration/level0/gcci_platform/import.sh
sudo chmod -R -f 777 /tf/avm/templates/landingzone/configuration

```


## Step 0 - create log analytics workspace ** OPTIONAL (for non-gcc environment only)

```bash
cd /tf/avm/templates/0-setup_subscription_law

terraform init -reconfigure
terraform plan
terraform apply -auto-approve
```

## Step 1: Generate config.yaml file

```bash
tfexe generate-config

```
#### How to Provide Inputs for Deployment of the Archetypes

* **PREFIX**: Your project’s unique identifier (e.g. `hc01-dev`)
* **RESOURCE GROUP NAME**: Name of the Azure Resource Group to host resources (e.g. `hc01-dev-platform`)
* **LOG ANALYTICS WORKSPACE RESOURCE GROUP NAME**: Name of the Resource Group hosting Log Analytics Workspace (default: `gcci-agency-law`)
* **LOG ANALYTICS WORKSPACE NAME**: Name of the Log Analytics Workspace (default: `gcci-agency-workspace`)
* **ENVIRONMENT**: Deployment environment (`dev`, `sit`, `uat`, `stg`, `prd`; default: `dev`)
* **LANDING ZONE TYPE**: Type of landing zone (Enter `1` = application)
* **COMPARTMENT TYPE**: Type of VNET compartment (Enter `3` = agency managed)
* **VNET PROJECT NAME**: Name of Project VNET (default: `gcci-vnet-project`)
* **VNET PROJECT CIDR**: CIDR of Project Agency Managed VNET (default: `192.168.0.0/23`)
* **VNET DEVOPS NAME**: Name of DevOps VNET (default: `gcci-vnet-devops`)
* **VNET DEVOPS CIDR**: CIDR of DevOps Agency Managed VNET (default: `192.168.10.0/24`)
* **ARCHETYPE**: Deployment archetype 
  - (Enter `1` = AI Foundry archetype)
  - (Enter `2` = AKS archetype)
  - (Enter `3` = App Service archetype)
  - (Enter `4` = IoT archetype)
  - (Enter `5` = VM + Logic App archetype)

## Step 1: Deploy 0-launchpad, 1-landingzones, 2-solution_accelerators

- set prefix and configuration
- modify /tf/avm/templates/landingzone/configuration/0-launchpad/scripts/config.yaml according to your vnet and subnet requirements
- ensure your *.hcl contains the tfexe commands that you want to execute

- EXAMPLE:
```bash
# generate config.yaml file
tfexe generate-config


tfexe apply run-all -include=/tf/avm/scripts/examples/run-all/azure_ai_foundry_pattern.hcl

```


# Cloning the starter repository

The starter repository contains the basic configuration files and scenarios. It will allow you to compose your configuration files in the integrated environment.
Clone the repository using the following command:

```bash
git clone https://github.com/AcceleratorFramew0rk/infra-starterkit.git
```
OR

Download the repo as a zip file.

* Open working folder with Visual Studio Code (Note: Reopen in container when prompt in VS Code)
  * (if required) Install VS Code Extension - Dev Containers
* Add a zsh terminal from VS Code
* Follow the steps in README.md file
  
- Perform login

```bash
az login --tenant xxxxxxxx-xxxxxx-xxxx-xxxx-xxxxxxxxxxxx # azure tenant id

az account set --subscription xxxxxxxx-xxxxxx-xxxx-xxxx-xxxxxxxxxxxx # subscription id

az account show # to show the current login account

SUBSCRIPTION_ID="xxxxxxxx-xxxxxx-xxxx-xxxx-xxxxxxxxxxxx"
export ARM_SUBSCRIPTION_ID="${SUBSCRIPTION_ID}"
```


## ** OPTIONAL: Setup GCC Simulator Environment (required for testing and non gcc environment)
```bash
cd /tf/avm/templates/0-setup_subscription_law
terraform init -reconfigure
terraform plan
terraform apply -auto-approve
```
## ** Ensure the below azure resources are created in <your subscription>
### Resource Group: gcci-agency-law
###  - Log Analytics Workspace:
###      - gcci-agency-workspace

# Deployment - For NEW deployment only.

- ** IMPORTANT: Edit the settings.yaml file to select which azure resources you want to deploy

- Execute the install script:
```bash
sudo chmod -R -f 777 /tf/avm/scripts
sudo chmod -R -f 777 /tf/avm/templates/landingzone/configuration

# deploy azure resources based on </tf/avm/scripts/config/settings.yaml> and prompt inputs
tfexe generate-config

# verify the content of config.yaml file in "/tf/avm/templates/landingzone/configuration/0-launchpad/scripts/config.yaml"

# exeute 01-launchpad import, 02-landingzones, 03-solution_accelerators
tfexe deploy-app-lz

```
# follow the instruction to enter PREFIX, PROJECT_VNET, DEVOPS VNET, ENVIRONMENT, Landingzone Type (app or infra)
  - If ran without options, the install script will first perform the infrastructure deployment through terraform using configuration in settings.yaml by default.



# deploy runner (if required)

cd /tf/avm/cicd/starter_vm

# follow the steps in the below readme file
./deploy-runner.md


# Deploy the starter kit
## Login to Azure
```bash
az login --tenant xxxxxxxx-xxxxxx-xxxx-xxxx-xxxxxxxxxxxx # azure tenant id

az account set --subscription xxxxxxxx-xxxxxx-xxxx-xxxx-xxxxxxxxxxxx # subscription id

az account show # to show the current login account

SUBSCRIPTION_ID="xxxxxxxx-xxxxxx-xxxx-xxxx-xxxxxxxxxxxx"
export ARM_SUBSCRIPTION_ID="${SUBSCRIPTION_ID}"

# ensure min "execute" right to script to avoid permission issue
sudo chmod -R -f 777 /tf/avm/templates/landingzone/configuration/level0/gcci_platform/import.sh
sudo chmod -R -f 777 /tf/avm/templates/landingzone/configuration


# continue with starter kit.

# To sign in, use a web browser to open the page 

# https://microsoft.com/devicelogin 

#and enter the code XXXXXXXXXXX to authenticate.

# follow the steps in /tf/avm/deploy_aks_appservice_archetype.md



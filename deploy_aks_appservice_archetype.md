## Login to Azure
```bash
az login --tenant xxxxxxxx-xxxxxx-xxxx-xxxx-xxxxxxxxxxxx # azure tenant id

az account set --subscription xxxxxxxx-xxxxxx-xxxx-xxxx-xxxxxxxxxxxx # subscription id

az account show # to show the current login account

SUBSCRIPTION_ID="xxxxxxxx-xxxxxx-xxxx-xxxx-xxxxxxxxxxxx"
export ARM_SUBSCRIPTION_ID="${SUBSCRIPTION_ID}"

```

# 0-launchpad ~ 5 mins
```bash
sudo chmod -R -f 777 /tf/avm/templates/landingzone/configuration/level0/gcci_platform/import.sh
sudo chmod -R -f 777 /tf/avm/templates/landingzone/configuration

cd /tf/avm/templates/landingzone/configuration/0-launchpad/launchpad

./scripts/import.sh

```

# 1-landingzone ~ 10 mins
```bash

cd /tf/avm/templates/landingzone/configuration/1-landingzones

./deploy_application_landingzone_script.sh

```


# 2-solution-accelerators ~ 2 hrs
```bash

cd /tf/avm/templates/landingzone/configuration/2-solution_accelerators
./deploy_pattern_aks_app_service_archetype.sh

```

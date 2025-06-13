


```bash

az login --tenant xxxxxxxx-xxxxxx-xxxx-xxxx-xxxxxxxxxxxx # azure tenant id

az account set --subscription xxxxxxxx-xxxxxx-xxxx-xxxx-xxxxxxxxxxxx # subscription id

az account show # to show the current login account

SUBSCRIPTION_ID="xxxxxxxx-xxxxxx-xxxx-xxxx-xxxxxxxxxxxx"
export ARM_SUBSCRIPTION_ID="${SUBSCRIPTION_ID}"

sudo chmod -R -f 777 /tf/avm/templates/landingzone/configuration
sudo chmod -R -f 777 /tf/avm/scripts


# 0-launchpad
tfexe import

# 1-landingzones
tfexe apply -path=/tf/avm/templates/landingzone/configuration/1-landingzones/application/networking_spoke_project
tfexe apply -path=/tf/avm/templates/landingzone/configuration/1-landingzones/application/networking_spoke_devops
tfexe apply -path=/tf/avm/templates/landingzone/configuration/1-landingzones/application/networking_peering_project_devops

# 2-solution accelerators

# container app ai services pattern
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/devops/containter_instance
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/container_app
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/ai_search_service
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/mssql

```
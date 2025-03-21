#!/bin/bash

source "./utils.sh"

# keyvault
tfignite apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/keyvault
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1

# app service

# Define the linux_fx_version string, default is "DOCKER|nginx" / "NODE:20-lts" 
linux_fx_version="DOCKER|nginx"

# Define the resource_names array string, default is two app service with names ["web","api"]
resource_names='["web"]'

tfignite apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/app_service \
-var="linux_fx_version=${linux_fx_version}" \
-var="resource_names=${resource_names}" 

[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1

# mssql
tfignite apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/mssql
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1

# storage account
tfignite apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/storage_account
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1

# apim
tfignite apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/apim
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1

# linux function app

# Define the site_config JSON as a HEREDOC
SITE_CONFIG_JSON=$(cat <<EOF
{
  "application_stack": {
    "container": {
      "dotnet_version": null,
      "java_version": null,
      "node_version": null,
      "powershell_core_version": null,
      "python_version": null,
      "go_version": null,
      "ruby_version": null,
      "java_server": null,
      "java_server_version": null,
      "php_version": null,
      "use_custom_runtime": null,
      "use_dotnet_isolated_runtime": null,
      "docker": [
        {
          "image_name": "nginx",
          "image_tag": "latest",
          "registry_url": "docker.io"
        }
      ]
    }
  }
}
EOF
)

tfignite apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/linux_function_app \
-var "site_config=${SITE_CONFIG_JSON}"
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1

# iot hub
tfignite apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/iot_hub
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1

# # event hubs
# tfignite apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/event_hubs
# [ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1

# data explorer
tfignite apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/data_explorer
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1


# vm for vnet data gateway (to be confirmed)
tfignite apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/vm
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1

# stream analytics (must be last solution accelerator to be deployed)
# ** IMPORTANT: This step requires event hubs, iot hub, data explorer and sql server to be deployed first
tfignite apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/stream_analytics
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1

# # # Approved managed endpoint via Azure CLI
# -----------------------------------------------
# execute approve managed endpoint - function in utils.sh
exec_approve_stream_analytics_managed_private_endpoint
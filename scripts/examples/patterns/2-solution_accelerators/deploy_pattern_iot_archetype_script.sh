#!/bin/bash

source "./utils.sh"

# keyvault
cd /tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/keyvault
terraform-init-custom
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1
terraform plan 
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1
terraform apply
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1

# app service
cd /tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/app_service


# Define the linux_fx_version string, default is "DOCKER|nginx" / "NODE:20-lts" 
linux_fx_version="DOCKER|nginx"

# Define the resource_names array string, default is two app service with names ["web","api"]
resource_names='["web"]'

terraform-init-custom
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1
terraform plan \
-var="linux_fx_version=${linux_fx_version}" \
-var="resource_names=${resource_names}" 
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1
terraform apply\
-var="linux_fx_version=${linux_fx_version}" \
-var="resource_names=${resource_names}" 
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1


# mssql
cd /tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/mssql
terraform-init-custom
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1
terraform plan 
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1
terraform apply
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1

# storage account
cd /tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/storage_account
terraform-init-custom
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1
terraform plan 
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1
terraform apply
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1

# apim
cd /tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/apim
terraform-init-custom
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1
terraform plan 
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1
terraform apply
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1


# linux function app
cd /tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/linux_function_app

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


terraform-init-custom
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1
terraform plan \
-var "site_config=${SITE_CONFIG_JSON}"
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1
terraform apply\
-var "site_config=${SITE_CONFIG_JSON}"
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1


# iot hub
cd /tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/iot_hub
terraform-init-custom
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1
terraform plan 
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1
terraform apply
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1

# # event hubs
# cd /tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/event_hubs
# terraform-init-custom
# [ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1
# terraform plan 
# [ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1
# terraform apply
# [ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1



# data explorer
cd /tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/data_explorer
terraform-init-custom
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1
terraform plan 
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1
terraform apply
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1


# vm for vnet data gateway (to be confirmed)
cd /tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/vm
terraform-init-custom
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1
terraform plan 
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1
terraform apply
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1



# stream analytics (must be last solution accelerator to be deployed)
# ** IMPORTANT: This step requires event hubs, iot hub, data explorer and sql server to be deployed first
cd /tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/stream_analytics
terraform-init-custom
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1
terraform plan 
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1
terraform apply
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1

# # # Approved managed endpoint via Azure CLI
# -----------------------------------------------
# execute approve managed endpoint - function in utils.sh
exec_approve_stream_analytics_managed_private_endpoint
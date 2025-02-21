# Navigate to the working directory where the Terraform configuration files are located
cd /tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/linux_function_app

# Run the Custom Terraform initialization script "terraform-init-custom" at location "/usr/local/bin" to set up the backend and providers
terraform-init-custom

# Generate an execution plan to preview the changes Terraform will make
terraform plan

# Apply the Terraform configuration and automatically approve changes without prompting for confirmation
terraform apply -auto-approve



# deploy a linux function app - publishing model = container
# mcr.microsoft.com/azure-functions/dotnet:4-appservice-quickstart

# Navigate to the working directory where the Terraform configuration files are located
cd /tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/linux_function_app

# Define the site_config JSON as a HEREDOC
SITE_CONFIG_JSON=$(cat <<EOF
{
  "container_registry_use_managed_identity": true
  "always_on": true
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
          "image_name": "azure-functions/dotnet",
          "image_tag": "4-appservice-quickstart",
          "registry_url": "mcr.microsoft.com"
        }
      ]
    }
  }
}
EOF
)



# Run the Custom Terraform initialization script "terraform-init-custom" at location "/usr/local/bin" to set up the backend and providers
terraform-init-custom

# Generate an execution plan to preview the changes Terraform will make
terraform plan \
-var "site_config=${SITE_CONFIG_JSON}"

# Apply the Terraform configuration and automatically approve changes without prompting for confirmation
terraform apply -auto-approve \
-var "site_config=${SITE_CONFIG_JSON}"


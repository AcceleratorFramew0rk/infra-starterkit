# Navigate to the working directory where the Terraform configuration files are located
cd /tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/app_service

# Run the Custom Terraform initialization script "terraform-init-custom" at location "/usr/local/bin" to set up the backend and providers
terraform-init-custom

# Generate an execution plan to preview the changes Terraform will make
terraform plan

# Apply the Terraform configuration and automatically approve changes without prompting for confirmation
terraform apply -auto-approve

# Linux ASP with one app service "web" and Publishing model = Container
# -----------------------------------------------------------------------------------

# Navigate to the working directory where the Terraform configuration files are located
cd /tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/app_service

linux_fx_version="DOCKER|nginx"
resource_names='["web"]'

# Run the Custom Terraform initialization script "terraform-init-custom" at location "/usr/local/bin" to set up the backend and providers
terraform-init-custom

# Generate an execution plan to preview the changes Terraform will make
terraform plan\
-var="linux_fx_version=${linux_fx_version}"  \
-var="resource_names=${resource_names}" 

# Apply the Terraform configuration and automatically approve changes without prompting for confirmation
terraform apply -auto-approve\
-var="linux_fx_version=${linux_fx_version}"  \
-var="resource_names=${resource_names}" 

# Linux ASP with two app service "web" and "api" in WebIntranetSubnet and AppServiceIntranetSubnet
# -----------------------------------------------------------------------------------

# Navigate to the working directory where the Terraform configuration files are located
cd /tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/app_service

# Run the Custom Terraform initialization script "terraform-init-custom" at location "/usr/local/bin" to set up the backend and providers
terraform-init-custom

# Generate an execution plan to preview the changes Terraform will make
terraform plan\
-var="subnet_name=AppServiceIntranetSubnet" \
-var="ingress_subnet_name=WebIntranetSubnet"

# Apply the Terraform configuration and automatically approve changes without prompting for confirmation
terraform apply -auto-approve\
-var="subnet_name=AppServiceIntranetSubnet" \
-var="ingress_subnet_name=WebIntranetSubnet"


# Windows ASP with two app service "web" and "api"
# -----------------------------------------------------------------------------------

# Navigate to the working directory where the Terraform configuration files are located
cd /tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/app_service

# Run the Custom Terraform initialization script "terraform-init-custom" at location "/usr/local/bin" to set up the backend and providers
terraform-init-custom

# Generate an execution plan to preview the changes Terraform will make
terraform plan \
-var="kind=Windows" \
-var="dotnet_framework_version=v6.0" 

# Apply the Terraform configuration and automatically approve changes without prompting for confirmation
terraform apply -auto-approve \
-var="kind=Windows" \
-var="dotnet_framework_version=v6.0" 


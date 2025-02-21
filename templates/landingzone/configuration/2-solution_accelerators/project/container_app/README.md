# Linux ASP with two app web and api
# -----------------------------------------------------------------------------------

# Navigate to the working directory where the Terraform configuration files are located
cd /tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/container_app

# Run the Custom Terraform initialization script "terraform-init-custom" at location "/usr/local/bin" to set up the backend and providers
terraform-init-custom

# Generate an execution plan to preview the changes Terraform will make
terraform plan

# Apply the Terraform configuration and automatically approve changes without prompting for confirmation
terraform apply -auto-approve

# Linux ASP with one app "web" 
# -----------------------------------------------------------------------------------

# Navigate to the working directory where the Terraform configuration files are located
cd /tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/container_app

resource_names='["web"]'

# Run the Custom Terraform initialization script "terraform-init-custom" at location "/usr/local/bin" to set up the backend and providers
terraform-init-custom

# Generate an execution plan to preview the changes Terraform will make
terraform plan\
-var="resource_names=${appservice_name}" 

# Apply the Terraform configuration and automatically approve changes without prompting for confirmation
terraform apply -auto-approve\
-var="resource_names=${appservice_name}" 


# Linux ASP with two app "web" and "api" in WebIntranetSubnet and ContainerAppIntranetSubnet
# -----------------------------------------------------------------------------------

# Navigate to the working directory where the Terraform configuration files are located
cd /tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/container_app

# Run the Custom Terraform initialization script "terraform-init-custom" at location "/usr/local/bin" to set up the backend and providers
terraform-init-custom

# Generate an execution plan to preview the changes Terraform will make
terraform plan\
-var="subnet_name=ContainerAppIntranetSubnet" \
-var="ingress_subnet_name=WebIntranetSubnet" 

# Apply the Terraform configuration and automatically approve changes without prompting for confirmation
terraform apply -auto-approve\
-var="subnet_name=ContainerAppIntranetSubnet" \
-var="ingress_subnet_name=WebIntranetSubnet" 

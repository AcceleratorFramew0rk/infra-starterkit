# Navigate to the working directory where the Terraform configuration files are located
cd /tf/avm/templates/landingzone/configuration/2-solution_accelerators/hub_intranet_egress/firewall_egress

# Run the **Custom** Terraform initialization script "terraform-init-custom" at location "/usr/local/bin" to set up the backend and providers
tfexe apply

# ------------------------------------------------------------------
# Deploy Azure Resource using -var-file option
# ------------------------------------------------------------------

```bash

cd /tf/avm/templates/landingzone/configuration/2-solution_accelerators/hub_internet_egress/firewall_egress
tfexe apply -var-file=./example/terraform.tfvars

```
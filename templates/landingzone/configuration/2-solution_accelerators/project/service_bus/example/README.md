# ------------------------------------------------------------------
# Deploy Azure Resource using -var-file option
# ------------------------------------------------------------------

```bash

cd /tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/service_bus
tfexe apply -var-file=./example/terraform.tfvars

```
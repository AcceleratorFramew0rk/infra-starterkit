# ------------------------------------------------------------------
# Deploy Azure Resource using -var-file option
# ------------------------------------------------------------------

```bash

cd /tf/avm/templates/landingzone/configuration/2-solution_accelerators/management/bastion_host
tfexe apply -var-file=./example/terraform.tfvars

```
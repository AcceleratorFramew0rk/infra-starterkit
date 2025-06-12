# Starter kit for GCC

## goto working directory
```bash
cd /tf/avm/templates
```

## (Optional) Setup GCC Simulator Development Environment
```bash
cd /tf/avm/templates/0-setup_gcc_dev_env

terraform init -reconfigure
terraform plan
terraform apply -auto-approve
```

## launchpad

### config.yaml

Please use VS Code to edit the config.yaml file located at /tf/avm/templates/landingzone/configuration/0-launchpad/launchpad/scripts. 
Review and, if necessary, modify the details of the project subnets and cidr ranges.


### import gcci tfstate and create launchpad storage account and containers
```bash
sudo chmod -R -f 777 /tf/avm/templates/landingzone/configuration/level0/gcci_platform/import.sh
sudo chmod -R -f 777 /tf/avm/templates/landingzone/configuration
cd /tf/avm/templates/landingzone/configuration/0-launchpad/launchpad_agency_managed_vnet

./scripts/import.sh
```

### deploy landing zones virtual networks
```bash
cd /tf/avm/templates/landingzone/configuration/1-landingzones/application/networking_spoke_project
tfexe apply
```
### deploy solution accelerators
```bash
# apim
cd /tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/apim
tfexe apply
```

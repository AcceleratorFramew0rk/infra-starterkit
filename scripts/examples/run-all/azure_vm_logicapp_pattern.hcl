# 0-launchpad
tfexe import 
# 1-landingzones
tfexe apply -path=/tf/avm/templates/landingzone/configuration/1-landingzones/application/networking_spoke_project
tfexe apply -path=/tf/avm/templates/landingzone/configuration/1-landingzones/application/networking_spoke_devops
tfexe apply -path=/tf/avm/templates/landingzone/configuration/1-landingzones/application/networking_peering_project_devops
# 2-solution_accelerators
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/keyvault 
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/storage_account
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/logic_app
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/vm -var=vm_count=2 -var=storage=32
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/vm -var=vm_count=1 -var=storage=512 -var=subnet_name=DbSubnet -backend-config-key=solution-accelerators-project-vm-db.tfstate
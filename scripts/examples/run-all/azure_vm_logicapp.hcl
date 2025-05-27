# 0-launchpad
tfexe import -path=/tf/avm/templates/landingzone/configuration/0-launchpad/launchpad_agency_managed_vnet
# 1-landingzones
tfexe apply -path=/tf/avm/templates/landingzone/configuration/1-landingzones/application/networking_spoke_project
tfexe apply -path=/tf/avm/templates/landingzone/configuration/1-landingzones/application/networking_spoke_devops
tfexe apply -path=/tf/avm/templates/landingzone/configuration/1-landingzones/application/networking_peering_project_devops
# 2-solution_accelerators
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/keyvault 
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/storage_account
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/logic_app
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/vm -var=vm_count=2
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/vm_db -var=subnet_name=DbSubnet
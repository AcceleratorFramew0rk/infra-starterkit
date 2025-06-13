# 0-launchpad
tfexe import 
# 1-landingzones
tfexe apply -path=/tf/avm/templates/landingzone/configuration/1-landingzones/application/networking_spoke_project
tfexe apply -path=/tf/avm/templates/landingzone/configuration/1-landingzones/application/networking_spoke_devops
tfexe apply -path=/tf/avm/templates/landingzone/configuration/1-landingzones/application/networking_peering_project_devops
# 2-solution_accelerators
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/devops/containter_instance
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/keyvault
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/acr
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/aks_avm_ptn
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/mssql
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/storage_account
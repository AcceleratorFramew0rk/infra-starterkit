# 0-launchpad
tfexe import 
# 1-landingzones
tfexe apply -path=/tf/avm/templates/landingzone/configuration/1-landingzones/application/networking_spoke_project
tfexe apply -path=/tf/avm/templates/landingzone/configuration/1-landingzones/application/networking_spoke_devops
tfexe apply -path=/tf/avm/templates/landingzone/configuration/1-landingzones/application/networking_peering_project_devops
# 2-solution_accelerators
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/container_app
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/keyvault
# ai_search+services: ai services, search services, storage account
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/ai_search_service
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/mssql


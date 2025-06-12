# 0-launchpad
tfexe import -path=/tf/avm/templates/landingzone/configuration/0-launchpad/launchpad_agency_managed_vnet
# 1-landingzones
tfexe apply -path=/tf/avm/templates/landingzone/configuration/1-landingzones/application/networking_spoke_project
tfexe apply -path=/tf/avm/templates/landingzone/configuration/1-landingzones/application/networking_spoke_devops
tfexe apply -path=/tf/avm/templates/landingzone/configuration/1-landingzones/application/networking_peering_project_devops
# 2-solution_accelerators
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/devops/containter_instance
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/storage_account
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/container_app
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/ai_services
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/search_service
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/mssql


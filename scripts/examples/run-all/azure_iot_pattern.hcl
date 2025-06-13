# 0-launchpad
tfexe import 
# 1-landingzones
tfexe apply -path=/tf/avm/templates/landingzone/configuration/1-landingzones/application/networking_spoke_project
tfexe apply -path=/tf/avm/templates/landingzone/configuration/1-landingzones/application/networking_spoke_devops
tfexe apply -path=/tf/avm/templates/landingzone/configuration/1-landingzones/application/networking_peering_project_devops
# 2-solution_accelerators
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/devops/containter_instance
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/keyvault
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/app_service
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/mssql
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/storage_account
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/apim
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/linux_function_app
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/iot_hub
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/data_explorer
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/stream_analytics
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/vm
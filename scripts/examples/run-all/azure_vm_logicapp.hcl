echo "2-solution_accelerators"
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/keyvault 
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/storage_account
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/logic_app
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/vm -var=vm_count=2
tfexe apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/project/vm -var=subnet_name=DbSubnet
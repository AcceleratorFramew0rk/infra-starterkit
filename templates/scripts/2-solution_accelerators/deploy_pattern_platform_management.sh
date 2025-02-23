#!/bin/bash

# management - bastion host
tfignite apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/management/bastion_host
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1

# management - tooling server
tfignite apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/management/vm
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1





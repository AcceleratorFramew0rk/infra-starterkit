#!/bin/bash

# devops runner
tfignite apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/devops/containter_instance
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1


#!/bin/bash

# spoke project 
tfignite apply -path=/tf/avm/templates/landingzone/configuration/1-landingzones/application/networking_spoke_project
[ $? -ne 0 ] && echo -e "\e[31mTerraform apply failed. Exiting.\e[0m" && exit 1

# spoke devops 
tfignite apply -path=/tf/avm/templates/landingzone/configuration/1-landingzones/application/networking_spoke_devops
[ $? -ne 0 ] && echo -e "\e[31mTerraform apply failed. Exiting.\e[0m" && exit 1

# peering project-devops
tfignite apply -path=/tf/avm/templates/landingzone/configuration/1-landingzones/application/networking_peering_project_devops
[ $? -ne 0 ] && echo -e "\e[31mTerraform apply failed. Exiting.\e[0m" && exit 1


#!/bin/bash

# internet ingress agw
tfignite apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/hub_internet_ingress/agw
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1

# internet ingress firewall
tfignite apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/hub_internet_ingress/firewall_ingress
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1





#!/bin/bash

# intranet ingress agw
tfignite apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/hub_intranet_ingress/agw
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1

# intranet ingress firewall
tfignite apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/hub_intranet_ingress/firewall_ingress
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1





#!/bin/bash

# egress internet
tfignite apply -path=/tf/avm/templates/landingzone/configuration/1-landingzones/platform/networking_hub_internet_egress
[ $? -ne 0 ] && echo -e "\e[31mTerraform apply failed. Exiting.\e[0m" && exit 1

# ingress internet
tfignite apply -path=/tf/avm/templates/landingzone/configuration/1-landingzones/platform/networking_hub_internet_ingress
[ $? -ne 0 ] && echo -e "\e[31mTerraform apply failed. Exiting.\e[0m" && exit 1

# egress intranet
tfignite apply -path=/tf/avm/templates/landingzone/configuration/1-landingzones/platform/networking_hub_intranet_egress
[ $? -ne 0 ] && echo -e "\e[31mTerraform apply failed. Exiting.\e[0m" && exit 1

# ingress intranet
tfignite apply -path=/tf/avm/templates/landingzone/configuration/1-landingzones/platform/networking_hub_intranet_ingress
[ $? -ne 0 ] && echo -e "\e[31mTerraform apply failed. Exiting.\e[0m" && exit 1

# management
tfignite apply -path=/tf/avm/templates/landingzone/configuration/1-landingzones/platform/networking_spoke_management
[ $? -ne 0 ] && echo -e "\e[31mTerraform apply failed. Exiting.\e[0m" && exit 1



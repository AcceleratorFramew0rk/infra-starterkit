#!/bin/bash

# intranet egress firewall
tfignite apply -path=/tf/avm/templates/landingzone/configuration/2-solution_accelerators/hub_intranet_egress/firewall_egress
[ $? -ne 0 ] && echo -e "\e[31mTerraform failed. Exiting.\e[0m" && exit 1

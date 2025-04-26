#!/bin/bash

# -----------------------------------------------------------------------------------------
# USAGE:
# cd $(pwd)/starterkit
# ./cicd/scripts/bin/deploy_1_landingzones.sh
# -----------------------------------------------------------------------------------------

# ** IMPORTANT: always start with top level path of starterkit

# CONFIG_PATH="$(pwd)/config.yaml"
CONFIG_PATH="./templates/landingzone/configuration/0-launchpad/scripts/config.yaml"

# project vnet
./scripts/bin/tfexe apply -path="./templates/landingzone/configuration/1-landingzones/application/networking_spoke_project"  -config="${CONFIG_PATH}"
if [ $? -ne 0 ]; then
    echo "Failed to import. Error in command [apply project]. Exiting."
    exit 1
fi

# devops vent
./scripts/bin/tfexe apply -path="./templates/landingzone/configuration/1-landingzones/application/networking_spoke_devops"  -config="${CONFIG_PATH}"
if [ $? -ne 0 ]; then
    echo "Failed to import. Error in command [app devops]. Exiting."
    exit 1
fi

# peering project devops
./scripts/bin/tfexe apply -path="./templates/landingzone/configuration/1-landingzones/application/networking_peering_project_devops" -config="${CONFIG_PATH}"
if [ $? -ne 0 ]; then
    echo "Failed to import. Error in command [app devops]. Exiting."
    exit 1
fi
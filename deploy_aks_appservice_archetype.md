# 0-launchpad
sudo chmod -R -f 777 /tf/avm/templates/landingzone/configuration/level0/gcci_platform/import.sh
sudo chmod -R -f 777 /tf/avm/templates/landingzone/configuration

cd /tf/avm/templates/landingzone/configuration/0-launchpad/launchpad

./scripts/import.sh

# 1-landingzone

cd /tf/avm/templates/landingzone/configuration/1-landingzones
./deploy_application_landingzone_script.sh


# 2-solution-accelerators

cd /tf/avm/templates/landingzone/configuration/2-solution_accelerators
./deploy_pattern_aks_app_service_archetype.sh

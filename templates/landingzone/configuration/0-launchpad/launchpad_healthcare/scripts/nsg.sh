
echo "-----------------------------------------------------------------------------"  
echo "Start creating NSG yaml configuration file"  
echo "-----------------------------------------------------------------------------"


# goto nsg configuration folder
cd /tf/avm/templates/landingzone/configuration/1-landingzones/scripts

# create nsg yaml file from nsg csv files
python3 csv_to_yaml.py 

# replace subnet cidr range from config.yaml file in launchpad
./replace.sh

echo "-----------------------------------------------------------------------------"  
echo "End creating NSG yaml configuration file"  
echo "-----------------------------------------------------------------------------"



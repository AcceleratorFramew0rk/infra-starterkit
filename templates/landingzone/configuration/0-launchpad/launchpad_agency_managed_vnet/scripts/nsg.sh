
echo "-----------------------------------------------------------------------------"  
echo "Start creating NSG yaml configuration file"  
echo "-----------------------------------------------------------------------------"

#------------------------------------------------------------------------
# working directory
#------------------------------------------------------------------------
# If $1 is unset or empty, default to /tf/avm
WORKING_DIR="${1:-/tf/avm}"

# goto nsg configuration folder
cd "${WORKING_DIR}/templates/landingzone/configuration/1-landingzones/scripts"

# create nsg yaml file from nsg csv files
python3 csv_to_yaml.py 
if [ $? -eq 0 ]; then
    echo "csv_to_yaml completed successfully."
else
    echo -e "\e[31mcsv_to_yaml failed. Exiting.\e[0m"
    exit 1
fi

# replace subnet cidr range from config.yaml file in launchpad
./replace.sh
if [ $? -eq 0 ]; then
    echo "replace.sh completed successfully."
else
    echo -e "\e[31mreplace.sh failed. Exiting.\e[0m"
    exit 1
fi

echo "-----------------------------------------------------------------------------"  
echo "End creating NSG yaml configuration file"  
echo "-----------------------------------------------------------------------------"



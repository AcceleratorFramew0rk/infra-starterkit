#!/bin/bash

# -----------------------------------------------------------------------------------------
# USAGE:
# cd $(pwd)/starterkit
# ./cicd/scripts/bin/deploy_2_solution_accelerators.sh
# -----------------------------------------------------------------------------------------

# ** IMPORTANT: always start with top level path of starterkit

WORKING_DIRECTORY=$(pwd) # pwd should always be ./starterkit or $(pwd)/starterkit
echo "WORKING_DIRECTORY:"
echo $WORKING_DIRECTORY

# location of code
data_file="./cicd/scripts/data.json"

# location of data: selectedServices and selectedServicesConfig
selected_services_file="./cicd/scripts/config/selectedServices.json"
data_file_config="./cicd/scripts/config/selectedServicesConfig.json"

echo "Data file: $data_file"
echo "Selected services file: $selected_services_file"
echo "Data file config: $data_file_config" 

# Key: service name, value: folder name in /tf/avm/templates/landingzone/configuration/2-solution_accelerators/project folder
# Loop through selectedServices.json

# the below is not working
# jq -c '.[]' "$selected_services_file" | while read -r item; do
#     key=$(echo "$item" | jq -r 'keys[0]')                # Extract the key (service name)
#     selected_value=$(echo "$item" | jq -r ".[\"$key\"]") # Extract the true/false value

jq -c 'to_entries[]' "$selected_services_file" | while read -r item; do
    key=$(echo "$item" | jq -r '.key')
    selected_value=$(echo "$item" | jq -r '.value')
    echo "Service: $key, Selected: $selected_value"

    if [ "$selected_value" == "true" ]; then
        # Check if the key exists in data file object
        value=$(jq -r --arg key "$key" '.[] | select(has($key)) | .[$key]' "$data_file")
        
        echo "key: $key"        
        echo "value: $value"
        echo "Value of $key: $value"
        
        if [ -n "$value" ] && [ "$value" != "null" ]; then
            echo "Key '$key' exists in JSON."
            path="$WORKING_DIRECTORY/templates/landingzone/configuration/2-solution_accelerators/project/$value"
            echo "Path: $path"
            echo "Value of $key: $path"

            fields=$(jq -r --arg key "$key" '.[] | select(.id == $key) | .fields' "$data_file_config")

            # Check for empty or null values
            if [ -z "$fields" ] || [ "$fields" == "null" ]; then
                echo "Error: No fields found for service ID 'key: $key - value: $value'"
                exit 1
            fi

            # tfString="./tfexe.sh apply -path=$path "
            config="$WORKING_DIRECTORY/templates/landingzone/configuration/0-launchpad/scripts/config.yaml"


            # non-production - testing
            # tfString="./scripts/bin/tfexe init -path=$path -config=$config"

            # production - ensure space behind $config
            tfString="./scripts/bin/tfexe apply -path=$path -config=$config "

            # retrieve -var for terraform command if available
            while read -r field; do
                field_name=$(echo "$field" | jq -r '.name')
                selected_value=$(echo "$field" | jq -r '.selectedValue')
                enabled=$(echo "$field" | jq -r '.enabled')
                var=$(echo "$field" | jq -r '.varName')

                echo "  Field: $field_name, Selected Value: $selected_value, enabled: $enabled, var: $var"

                # Append to varString
                if [ -n "$var" ] && [ "$var" != "null" ]; then
                  tfString+="-var=${var}=${selected_value} "
                fi

            done <<< "$(echo "$fields" | jq -c '.[]')"  # Avoids subshell issue

            echo "Executing ...:"
            echo "$tfString"            

            # # uncomment when testing completed
            eval "$tfString"
            if [ $? -ne 0 ]; then
                echo "Error: Command execution failed."
                echo "Failed command: $tfString"                
                exit 1
            fi

        else
            echo "Key '$key' does NOT exist in JSON."             
            exit 1
        fi
    fi
done

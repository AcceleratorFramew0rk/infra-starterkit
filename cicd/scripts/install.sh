#!/bin/bash

data_file="$(pwd)/starterkit/cicd/scripts/data.json"
selected_services_file="$(pwd)/starterkit/cicd/scripts/config/selectedServices.json"
data_file_config="$(pwd)/starterkit/cicd/scripts/config/selectedServicesConfig.json"
echo "Data file: $data_file"
echo "Selected services file: $selected_services_file"
echo "Data file config: $data_file_config" # test
# Loop through selectedServices.json
jq -c '.[]' "$selected_services_file" | while read -r item; do
    key=$(echo "$item" | jq -r 'keys[0]')                # Extract the key (service name)
    selected_value=$(echo "$item" | jq -r ".[\"$key\"]") # Extract the true/false value
    
    if [ "$selected_value" == "true" ]; then
        # Check if the key exists in data file object
        value=$(jq -r --arg key "$key" '.[] | select(has($key)) | .[$key]' "$data_file")
        echo "Value of $key: $value"
        
        if [ -n "$value" ] && [ "$value" != "null" ]; then
            echo "Key '$key' exists in JSON."
            path="$(pwd)/starterkit/templates/landingzone/configuration/2-solution_accelerators/project/$value"
            echo "Value of $key: $path"

            fields=$(jq -r --arg key_value "$value" '.[] | select(.id == $key_value) | .fields' "$data_file_config")

            # Check for empty or null values
            if [ -z "$fields" ] || [ "$fields" == "null" ]; then
                echo "Error: No fields found for service ID '$key_value'"
                exit 1
            fi

            # tfString="./tfexe.sh apply -path=$path "
            config="$(pwd)/config.yaml"


            # testing
            # tfString="$(pwd)/starterkit/cicd/scripts/tfexe init -path=$path -config=$config"

            # production
            tfString="$(pwd)/starterkit/cicd/scripts/tfexe apply -path=$path -config=$config"

            # retrieve -var for terraform command if available
            while read -r field; do
                field_name=$(echo "$field" | jq -r '.name')
                selected_value=$(echo "$field" | jq -r '.selectedValue')
                enabled=$(echo "$field" | jq -r '.enabled')
                var=$(echo "$field" | jq -r '.varName')

                echo "  Field: $field_name, Selected Value: $selected_value, enabled: $enabled, var: $var"

                # Append to varString
                if [ -n "$var" ] && [ "$var" != "null" ]; then
                  tfString+="-var=\"${var}=${selected_value}\" "
                fi

            done <<< "$(echo "$fields" | jq -c '.[]')"  # Avoids subshell issue

            echo "Executing ...: $tfString"

            # # uncomment when testing completed
            eval "$tfString"
            if [ $? -ne 0 ]; then
                echo "Error: Command execution failed."
                echo "Failed command: $tfString"                
                exit 1
            fi

        else
            echo "Key '$key' does NOT exist in JSON."
        fi
    fi
done

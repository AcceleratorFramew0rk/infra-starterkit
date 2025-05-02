#!/bin/bash


# USAGE:
# exec_solution_accelerators.sh <path_to_settings_yaml_file> <path_to_config_yaml_file> <landingzone_type>

#------------------------------------------------------------------------
# 2-solution accelerators
#------------------------------------------------------------------------

# goto working directory
cd /tf/avm/scripts

# Initialize empty array
success_items=()

# Define the YAML file path
yaml_file=$1 # "/tf/avm/scripts/config/settings.yaml"
config_file=$2 # "/tf/avm/scripts/config/settings.yaml"
landingzone_type=$3 # "/tf/avm/scripts/config/settings.yaml"


if [[ -z "$yaml_file" ]]; then
  echo "Usage: $0 <path_to_settings_yaml_file> <path_to_config_yaml_file>"
  exit 1
fi

if [[ -z "$config_file" ]]; then
  echo "set the default config file path to /tf/avm/templates/landingzone/configuration/0-launchpad/scripts/config.yaml"
  config_file="/tf/avm/templates/landingzone/configuration/0-launchpad/scripts/config.yaml"
fi

# Check if the file exists
if [[ ! -f "$yaml_file" ]]; then
  echo "YAML file not found: $yaml_file"
  exit 1
fi

# Loop through the top-level keys
for section in $(yq 'keys | .[]' "$yaml_file" -r); do
  echo "Section: $section"

  # Loop through sub-keys for each top-level key
  for key in $(yq ".${section} | keys | .[]" "$yaml_file" -r); do
    value=$(yq ".${section}.${key}" "$yaml_file" -r)

    if [ $value = "true" ]; then
      echo "processing $key: $value"

      clean_key="${key//_/}"
      backend_config_key="solution-accelerators-${section}-${clean_key}"
      working_path="/tf/avm/templates/landingzone/configuration/2-solution_accelerators/${section}/${key}"
      echo "backend_config_key: $backend_config_key"
      echo "working_path: $working_path"

      # exec_terraform $backend_config_key $working_path $RG_NAME $STG_NAME "2-solution-accelerators" 
      if [[ "$landingzone_type" == "application"  || "$landingzone_type" == "1" ]]; then
        if [[ "$section" == "project"  || "$section" == "devops" ]]; then
          tfexe apply -path=$working_path -config=$config_file
          if [ $? -ne 0 ]; then
            echo -e "     "
            echo -e "\e[31mTerraform apply failed for ${working_path}. Exiting.\e[0m"
            exit 1
          else
            success_items+=("${working_path}")
          fi

        else
          echo "Item not configure in application landing zone. skip ${section} ${key}"
        fi
      else
        if [[ "$section" == "hub_internet_ingress"  || "$section" == "hub_internet_egress" || "$section" == "hub_intranet_ingress" || "$section" == "hub_intranet_egress" || "$section" == "management" ]]; then
          tfexe apply -path=$working_path -config=$config_file
          if [ $? -ne 0 ]; then
            echo -e "     "
            echo -e "\e[31mTerraform apply failed for ${config_file}. Exiting.\e[0m"
            exit 1
          else
            success_items+=("${working_path}")
          fi
        else
          echo "Item not configure in infra landing zone. skip ${section} ${key}"
        fi
      fi      

    else
      # echo "skip ${section} ${key}"
      echo " "      
    fi

  done
done

echo " "
echo "You have successfully deployed the following items:"
echo -e "\e[32mYou have successfully deployed the following items:\e[0m"  
for item in "${success_items[@]}"; do
  echo -e "\e[32m${item}\e[0m"  
done

#------------------------------------------------------------------------
# end 2-solution accelerators
#------------------------------------------------------------------------

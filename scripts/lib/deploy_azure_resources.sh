#!/bin/bash


#------------------------------------------------------------------------
# USAGE:
# exec_solution_accelerators.sh <path_to_settings_yaml_file> <path_to_config_yaml_file> <landingzone_type>
# EXAMPLE: 
# ./../lib/deploy_azure_resources.sh "/tf/avm/scripts/config/settings.yaml" "/tf/avm/templates/landingzone/configuration/0-launchpad/scripts/config.yaml" "1"
# ./../lib/deploy_azure_resources.sh "/tf/avm/scripts/config/settings_platform_landing_zone.yaml" "/tf/avm/templates/landingzone/configuration/0-launchpad/scripts/config.yaml" "2"
#------------------------------------------------------------------------


#------------------------------------------------------------------------
# 2-solution accelerators
#------------------------------------------------------------------------

# goto working directory
cd /tf/avm/scripts

# Define the YAML file path
yaml_file=$1 
config_file=$2 
landingzone_type=$3 


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


# Read the YAML as JSON and preserve key order using yq and jq
while IFS= read -r section_entry; do
  section=$(echo "$section_entry" | jq -r '.key')
  echo "Section: $section"

  echo "$section_entry" | jq -c '.value | to_entries[]' > tmp_kv.json
  while IFS= read -r kv; do
    key=$(echo "$kv" | jq -r '.key')
    value=$(echo "$kv" | jq -r '.value')

    if [ "$value" = "true" ]; then
      echo "processing $key: $value"

      clean_key="${key//_/}"
      clean_section="${section//_/-}"
      backend_config_key="solution-accelerators-${clean_section}-${clean_key}"
      working_path="/tf/avm/templates/landingzone/configuration/2-solution_accelerators/${section}/${key}"
      echo "backend_config_key: $backend_config_key"
      echo "working_path: $working_path"

      if [[ "$landingzone_type" == "application"  || "$landingzone_type" == "1" ]]; then
        if [[ "$section" == "project"  || "$section" == "devops" ]]; then
          # tfexe init -path="$working_path" -config="$config_file"
          # testing
          # exit 1
          tfexe apply -path="$working_path" -config="$config_file"
          if [ $? -ne 0 ]; then
            echo -e "\e[31mTerraform apply failed for ${working_path}. Exiting.\e[0m"
            exit 1
          fi
        else
          echo "Item not configured in application landing zone. skip ${section} ${key}"
        fi
      else
        if [[ "$section" == "hub_internet_ingress"  || "$section" == "hub_internet_egress" || "$section" == "hub_intranet_ingress" || "$section" == "hub_intranet_egress" || "$section" == "management" ]]; then
          # tfexe init -path="$working_path" -config="$config_file"
          # testing
          # exit 1
          tfexe apply -path="$working_path" -config="$config_file"
          if [ $? -ne 0 ]; then
            echo -e "\e[31mTerraform apply failed for ${config_file}. Exiting.\e[0m"
            exit 1
          fi
        else
          echo "Item not configured in infra landing zone. skip ${section} ${key}"
        fi
      fi
    fi
  done < tmp_kv.json
done < <(yq '.' "$yaml_file" | jq -c 'to_entries[]')




# yq '.' "$yaml_file" | jq -c 'to_entries[]' | while read -r section_entry; do

#   section=$(echo "$section_entry" | jq -r '.key')
#   echo "Section: $section"

#   echo "$section_entry" | jq -c '.value | to_entries[]' | while read -r kv; do

#     key=$(echo "$kv" | jq -r '.key')
#     value=$(echo "$kv" | jq -r '.value')

#     if [ $value = "true" ]; then
#       echo "processing $key: $value"

#       clean_key="${key//_/}"
#       clean_section="${section//_/-}"
#       backend_config_key="solution-accelerators-${clean_section}-${clean_key}"
#       working_path="/tf/avm/templates/landingzone/configuration/2-solution_accelerators/${section}/${key}"
#       echo "backend_config_key: $backend_config_key"
#       echo "working_path: $working_path"

#       # exec_terraform $backend_config_key $working_path $RG_NAME $STG_NAME "2-solution-accelerators" 
#       if [[ "$landingzone_type" == "application"  || "$landingzone_type" == "1" ]]; then
#         if [[ "$section" == "project"  || "$section" == "devops" ]]; then
#           # testing
#           tfexe init -path=$working_path -config=$config_file
#           has_error="1"
#           # tfexe apply -path=$working_path -config=$config_file
#           if [ $? -ne 0 ]; then
#             echo -e "     "
#             echo -e "\e[31mTerraform apply failed for ${working_path}. Exiting.\e[0m"
#             has_error="1"
#             exit 1
#           fi

#         else
#           echo "Item not configure in application landing zone. skip ${section} ${key}"
#         fi
#       else
#         if [[ "$section" == "hub_internet_ingress"  || "$section" == "hub_internet_egress" || "$section" == "hub_intranet_ingress" || "$section" == "hub_intranet_egress" || "$section" == "management" ]]; then
#           # testing
#           tfexe init -path=$working_path -config=$config_file
#           has_error="1"
#           # tfexe apply -path=$working_path -config=$config_file
#           if [ $? -ne 0 ]; then
#             echo -e "     "
#             echo -e "\e[31mTerraform apply failed for ${config_file}. Exiting.\e[0m"
#             has_error="1"
#             exit 1
#           fi
#         else
#           echo "Item not configure in infra landing zone. skip ${section} ${key}"
#         fi
#       fi      

#     fi

#   done
  
# done


echo " "
echo -e "\e[32mYou have successfully completed deploy_azure_resources.sh\e[0m"  


#------------------------------------------------------------------------
# end 2-solution accelerators
#------------------------------------------------------------------------

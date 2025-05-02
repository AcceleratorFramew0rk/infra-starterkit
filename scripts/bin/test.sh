yaml_file="/tf/avm/scripts/config/settings.yaml"

# Read the YAML as JSON and preserve key order using yq and jq
yq '.' "$yaml_file" | jq -c 'to_entries[]' | while read -r section_entry; do
  section=$(echo "$section_entry" | jq -r '.key')
  echo "Section: $section"

  echo "$section_entry" | jq -c '.value | to_entries[]' | while read -r kv; do
    key=$(echo "$kv" | jq -r '.key')
    value=$(echo "$kv" | jq -r '.value')

    if [ "$value" = "true" ]; then
      echo "processing $key: $value"
    else
      echo " "
    fi
  done
done

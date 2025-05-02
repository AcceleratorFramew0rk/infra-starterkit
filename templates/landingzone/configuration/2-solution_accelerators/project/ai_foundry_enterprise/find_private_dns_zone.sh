# USAGE:
# data "external" "private_dns_zone_lookup" {
#   program = ["bash", "${path.module}/scripts/find_private_dns_zone.sh"]
#   query = {
#     dns_zone_name = "privatelink.blob.core.windows.net" # var.private_dns_zone_name
#   }
# }

# output "private_dns_zone_id" {
#   value = lookup(data.external.private_dns_zone_lookup.result, "id", null)
# }


#!/bin/bash
set -e

# Query Azure CLI to find the zone
#!/bin/bash
set -e

# Read the input JSON
read INPUT_JSON

DNS_ZONE_NAME=$(echo "$INPUT_JSON" | jq -r .dns_zone_name)

# Query Azure CLI
ZONE_ID=$(az network private-dns zone list --query "[?name=='${DNS_ZONE_NAME}'].id" -o tsv)

# Return JSON output
if [ -n "$ZONE_ID" ]; then
  echo "{\"id\": \"$ZONE_ID\"}"
else
  echo "{}"
fi

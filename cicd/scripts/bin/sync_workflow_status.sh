# get inputs
GITHUB_RUN_ID=$1
TRANSACTION_ID=$2
STATUS=$3
TOKEN=$4

# TODO - add token
curl -X POST "https://portal.sandpitlabs.com/api/receive_run_id" \
  -H "Content-Type: application/json" \
  -d "{\"run_id\": \"$GITHUB_RUN_ID\", \"transaction_id\": \"$TRANSACTION_ID\", \"status\": \"$STATUS\"}"

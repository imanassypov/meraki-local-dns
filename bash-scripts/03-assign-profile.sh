#!/bin/bash
# Assign DNS Profile to Network
# Usage: ./03-assign-profile.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.env"

if [ -z "$PROFILE_ID" ]; then
  echo "❌ Error: PROFILE_ID not set in config.env"
  exit 1
fi

if [ -z "$NETWORK_ID" ]; then
  echo "❌ Error: NETWORK_ID not set in config.env"
  exit 1
fi

echo "Assigning profile $PROFILE_ID to network $NETWORK_ID"

RESPONSE=$(curl -s -X POST \
  "$BASE_URL/organizations/$ORGANIZATION_ID/appliance/dns/local/profiles/assignments/bulkCreate" \
  -H "X-Cisco-Meraki-API-Key: $MERAKI_API_KEY" \
  -H "Content-Type: application/json" \
  -d "{
    \"items\": [
      {
        \"network\": {\"id\": \"$NETWORK_ID\"},
        \"profile\": {\"id\": \"$PROFILE_ID\"}
      }
    ]
  }")

echo "$RESPONSE" | jq .

ASSIGNMENT_ID=$(echo "$RESPONSE" | jq -r '.items[0].assignmentId')

if [ "$ASSIGNMENT_ID" != "null" ] && [ -n "$ASSIGNMENT_ID" ]; then
  echo ""
  echo "✅ Profile assigned to network successfully!"
  echo "📝 Assignment ID: $ASSIGNMENT_ID"
else
  echo "❌ Failed to assign profile"
  exit 1
fi

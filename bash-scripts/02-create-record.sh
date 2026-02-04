#!/bin/bash
# Create a Local DNS Record
# Usage: ./02-create-record.sh "hostname" "ip_address"

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.env"

HOSTNAME="${1:-www.example.local}"
ADDRESS="${2:-10.1.1.100}"

if [ -z "$PROFILE_ID" ]; then
  echo "❌ Error: PROFILE_ID not set in config.env"
  echo "   Run 01-create-profile.sh first"
  exit 1
fi

echo "Creating DNS record: $HOSTNAME -> $ADDRESS"
echo "Profile ID: $PROFILE_ID"

RESPONSE=$(curl -s -X POST \
  "$BASE_URL/organizations/$ORGANIZATION_ID/appliance/dns/local/records" \
  -H "X-Cisco-Meraki-API-Key: $MERAKI_API_KEY" \
  -H "Content-Type: application/json" \
  -d "{
    \"hostname\": \"$HOSTNAME\",
    \"address\": \"$ADDRESS\",
    \"profile\": {\"id\": \"$PROFILE_ID\"}
  }")

echo "$RESPONSE" | jq .

# Extract recordId
RECORD_ID=$(echo "$RESPONSE" | jq -r '.recordId')

if [ "$RECORD_ID" != "null" ] && [ -n "$RECORD_ID" ]; then
  echo ""
  echo "✅ Record created successfully!"
  echo "📝 Record ID: $RECORD_ID"
  echo ""
  echo "Update your config.env with:"
  echo "export RECORD_ID=\"$RECORD_ID\""
else
  echo "❌ Failed to create record"
  exit 1
fi

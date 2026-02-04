#!/bin/bash
# Create a Local DNS Profile
# Usage: ./01-create-profile.sh "Profile Name"

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.env"

PROFILE_NAME="${1:-Internal DNS}"

echo "Creating DNS profile: $PROFILE_NAME"

RESPONSE=$(curl -s -X POST \
  "$BASE_URL/organizations/$ORGANIZATION_ID/appliance/dns/local/profiles" \
  -H "X-Cisco-Meraki-API-Key: $MERAKI_API_KEY" \
  -H "Content-Type: application/json" \
  -d "{\"name\": \"$PROFILE_NAME\"}")

echo "$RESPONSE" | jq .

# Extract profileId
PROFILE_ID=$(echo "$RESPONSE" | jq -r '.profileId')

if [ "$PROFILE_ID" != "null" ] && [ -n "$PROFILE_ID" ]; then
  echo ""
  echo "✅ Profile created successfully!"
  echo "📝 Profile ID: $PROFILE_ID"
  echo ""
  echo "Update your config.env with:"
  echo "export PROFILE_ID=\"$PROFILE_ID\""
else
  echo "❌ Failed to create profile"
  exit 1
fi

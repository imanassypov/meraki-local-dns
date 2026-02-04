#!/bin/bash
# Delete a DNS Profile
# Usage: ./delete-profile.sh <profileId>

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.env"

PROFILE_TO_DELETE="${1:-$PROFILE_ID}"

if [ -z "$PROFILE_TO_DELETE" ]; then
  echo "❌ Error: Profile ID required"
  echo "Usage: ./delete-profile.sh <profileId>"
  exit 1
fi

echo "⚠️  Deleting profile: $PROFILE_TO_DELETE"
read -p "Are you sure? (y/N) " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
  HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE \
    "$BASE_URL/organizations/$ORGANIZATION_ID/appliance/dns/local/profiles/$PROFILE_TO_DELETE" \
    -H "X-Cisco-Meraki-API-Key: $MERAKI_API_KEY")

  if [ "$HTTP_CODE" == "204" ]; then
    echo "✅ Profile deleted successfully"
  else
    echo "❌ Failed to delete profile (HTTP $HTTP_CODE)"
    exit 1
  fi
else
  echo "Cancelled"
fi

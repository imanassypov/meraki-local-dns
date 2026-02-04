#!/bin/bash
# List all DNS Records
# Usage: ./list-records.sh [profileId]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.env"

FILTER_PROFILE="${1:-}"

echo "Fetching DNS records for organization $ORGANIZATION_ID..."

URL="$BASE_URL/organizations/$ORGANIZATION_ID/appliance/dns/local/records"

if [ -n "$FILTER_PROFILE" ]; then
  URL="$URL?profileIds[]=$FILTER_PROFILE"
  echo "Filtering by profile: $FILTER_PROFILE"
fi

curl -s -X GET "$URL" \
  -H "X-Cisco-Meraki-API-Key: $MERAKI_API_KEY" \
  -H "Accept: application/json" | jq .

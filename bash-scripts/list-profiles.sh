#!/bin/bash
# List all DNS Profiles
# Usage: ./list-profiles.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.env"

echo "Fetching DNS profiles for organization $ORGANIZATION_ID..."

curl -s -X GET \
  "$BASE_URL/organizations/$ORGANIZATION_ID/appliance/dns/local/profiles" \
  -H "X-Cisco-Meraki-API-Key: $MERAKI_API_KEY" \
  -H "Accept: application/json" | jq .

#!/bin/bash
# List Profile Assignments
# Usage: ./list-assignments.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.env"

echo "Fetching profile assignments for organization $ORGANIZATION_ID..."

curl -s -X GET \
  "$BASE_URL/organizations/$ORGANIZATION_ID/appliance/dns/local/profiles/assignments" \
  -H "X-Cisco-Meraki-API-Key: $MERAKI_API_KEY" \
  -H "Accept: application/json" | jq .

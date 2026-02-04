#!/bin/bash
# Delete a DNS Record
# Usage: ./delete-record.sh <recordId>

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.env"

RECORD_TO_DELETE="${1:-$RECORD_ID}"

if [ -z "$RECORD_TO_DELETE" ]; then
  echo "❌ Error: Record ID required"
  echo "Usage: ./delete-record.sh <recordId>"
  exit 1
fi

echo "⚠️  Deleting record: $RECORD_TO_DELETE"
read -p "Are you sure? (y/N) " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
  HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE \
    "$BASE_URL/organizations/$ORGANIZATION_ID/appliance/dns/local/records/$RECORD_TO_DELETE" \
    -H "X-Cisco-Meraki-API-Key: $MERAKI_API_KEY")

  if [ "$HTTP_CODE" == "204" ]; then
    echo "✅ Record deleted successfully"
  else
    echo "❌ Failed to delete record (HTTP $HTTP_CODE)"
    exit 1
  fi
else
  echo "Cancelled"
fi

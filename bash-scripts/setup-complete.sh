#!/bin/bash
# Complete setup: Create profile, record, and assign to network
# Usage: ./setup-complete.sh "Profile Name" "hostname" "ip_address"

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.env"

PROFILE_NAME="${1:-Internal DNS}"
HOSTNAME="${2:-www.example.local}"
ADDRESS="${3:-10.1.1.100}"

echo "=========================================="
echo "Meraki Local DNS Complete Setup"
echo "=========================================="
echo "Profile Name: $PROFILE_NAME"
echo "DNS Record:   $HOSTNAME -> $ADDRESS"
echo "Network ID:   $NETWORK_ID"
echo "=========================================="
echo ""

# Step 1: Create Profile
echo "Step 1/3: Creating DNS profile..."
PROFILE_RESPONSE=$(curl -s -X POST \
  "$BASE_URL/organizations/$ORGANIZATION_ID/appliance/dns/local/profiles" \
  -H "X-Cisco-Meraki-API-Key: $MERAKI_API_KEY" \
  -H "Content-Type: application/json" \
  -d "{\"name\": \"$PROFILE_NAME\"}")

PROFILE_ID=$(echo "$PROFILE_RESPONSE" | jq -r '.profileId')

if [ "$PROFILE_ID" == "null" ] || [ -z "$PROFILE_ID" ]; then
  echo "❌ Failed to create profile"
  echo "$PROFILE_RESPONSE" | jq .
  exit 1
fi
echo "✅ Profile created: $PROFILE_ID"

# Step 2: Create Record
echo ""
echo "Step 2/3: Creating DNS record..."
RECORD_RESPONSE=$(curl -s -X POST \
  "$BASE_URL/organizations/$ORGANIZATION_ID/appliance/dns/local/records" \
  -H "X-Cisco-Meraki-API-Key: $MERAKI_API_KEY" \
  -H "Content-Type: application/json" \
  -d "{
    \"hostname\": \"$HOSTNAME\",
    \"address\": \"$ADDRESS\",
    \"profile\": {\"id\": \"$PROFILE_ID\"}
  }")

RECORD_ID=$(echo "$RECORD_RESPONSE" | jq -r '.recordId')

if [ "$RECORD_ID" == "null" ] || [ -z "$RECORD_ID" ]; then
  echo "❌ Failed to create record"
  echo "$RECORD_RESPONSE" | jq .
  exit 1
fi
echo "✅ Record created: $RECORD_ID"

# Step 3: Assign to Network
echo ""
echo "Step 3/3: Assigning profile to network..."
ASSIGN_RESPONSE=$(curl -s -X POST \
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

ASSIGNMENT_ID=$(echo "$ASSIGN_RESPONSE" | jq -r '.items[0].assignmentId')

if [ "$ASSIGNMENT_ID" == "null" ] || [ -z "$ASSIGNMENT_ID" ]; then
  echo "❌ Failed to assign profile"
  echo "$ASSIGN_RESPONSE" | jq .
  exit 1
fi
echo "✅ Profile assigned: $ASSIGNMENT_ID"

# Summary
echo ""
echo "=========================================="
echo "✅ Setup Complete!"
echo "=========================================="
echo "Profile ID:    $PROFILE_ID"
echo "Record ID:     $RECORD_ID"
echo "Assignment ID: $ASSIGNMENT_ID"
echo ""
echo "DNS Resolution: $HOSTNAME -> $ADDRESS"
echo "=========================================="
echo ""
echo "Save these IDs to config.env:"
echo "export PROFILE_ID=\"$PROFILE_ID\""
echo "export RECORD_ID=\"$RECORD_ID\""

# Meraki Local DNS - Bruno API Collection

A Bruno API collection for managing Local DNS records on Cisco Meraki MX appliances.

## Overview

This collection provides API requests for managing local DNS on Meraki MX security appliances. Local DNS allows the MX to respond to DNS queries locally for configured domains, which is useful when using public DNS services like OpenDNS while still requiring local name resolution for internal resources.

## Prerequisites

Before using these APIs, ensure:

- MX appliance running **firmware 19.1+**
- MX configured in **NAT/Routed Mode**
- **"Proxy to Upstream DNS"** enabled for the respective subnet (DHCP settings)
- **Non-Template MX network** (Templates are not supported via API)

## Collection Structure

```
bruno-collection/
├── bruno.json                    # Collection metadata
├── collection.bru                # Collection auth settings
├── environments/
│   ├── Production.bru            # Production environment variables
│   └── Sandbox.bru               # Sandbox environment variables
├── Profiles/
│   ├── Create Local DNS Profile.bru
│   ├── List Local DNS Profiles.bru
│   └── Delete Local DNS Profile.bru
├── Records/
│   ├── Create Local DNS Record.bru
│   ├── List Local DNS Records.bru
│   └── Delete Local DNS Record.bru
└── Assignments/
    ├── Assign Profile to Networks.bru
    └── List Profile Assignments.bru
```

## Setup

### 1. Install Bruno

Download Bruno from [usebruno.com](https://www.usebruno.com/) or install via:

```bash
# macOS
brew install bruno

# or download from website for other platforms
```

### 2. Open Collection

1. Open Bruno
2. Click **Open Collection**
3. Navigate to `bruno-collection` folder
4. Select the folder

### 3. Configure Environment

1. Click on **Environments** in Bruno
2. Select **Production** or **Sandbox**
3. Set your variables:
   - `MERAKI_API_KEY`: Your Meraki Dashboard API key (stored as secret)
   - `organizationId`: Your Meraki organization ID
   - `profileId`: (Optional) Default profile ID for operations
   - `recordId`: (Optional) Default record ID for operations
   - `networkId`: (Optional) Default network ID for assignments

### 4. Get Your API Key

1. Log into [Meraki Dashboard](https://dashboard.meraki.com)
2. Go to **Organization > Settings**
3. Enable API access
4. Go to your profile and generate an API key

### 5. Find Your Organization ID

Run the "List Organizations" request or find it in Dashboard URL:
```
https://dashboard.meraki.com/o/{organizationId}/...
```

## Workflow

### Typical Setup Flow

1. **Create a DNS Profile**
   - Run `Profiles > Create Local DNS Profile`
   - Note the `profileId` from response

2. **Add DNS Records to Profile**
   - Update `profileId` in environment or request body
   - Run `Records > Create Local DNS Record`
   - Repeat for each hostname/IP mapping

3. **Assign Profile to Network(s)**
   - Update `networkId` and `profileId` in environment
   - Run `Assignments > Assign Profile to Networks`

### Managing Records

- **List all records**: `Records > List Local DNS Records`
- **Filter by profile**: Add `profileIds` query parameter
- **Delete a record**: Set `recordId` and run `Records > Delete Local DNS Record`

## API Endpoints Reference

| Operation | Method | Endpoint |
|-----------|--------|----------|
| Create Profile | POST | `/organizations/{orgId}/appliance/dns/local/profiles` |
| List Profiles | GET | `/organizations/{orgId}/appliance/dns/local/profiles` |
| Delete Profile | DELETE | `/organizations/{orgId}/appliance/dns/local/profiles/{profileId}` |
| Create Record | POST | `/organizations/{orgId}/appliance/dns/local/records` |
| List Records | GET | `/organizations/{orgId}/appliance/dns/local/records` |
| Delete Record | DELETE | `/organizations/{orgId}/appliance/dns/local/records/{recordId}` |
| Assign Profile | POST | `/organizations/{orgId}/appliance/dns/local/profiles/assignments/bulkCreate` |
| List Assignments | GET | `/organizations/{orgId}/appliance/dns/local/profiles/assignments` |

## Limits

- **Maximum 1024 local DNS records per MX device**

## Documentation

- [Meraki Local DNS Service Documentation](https://documentation.meraki.com/SASE_and_SD-WAN/MX/Operate_and_Maintain/How-Tos/Local_DNS_Service_on_MX)
- [Meraki Dashboard API Documentation](https://developer.cisco.com/meraki/api-v1/)

## Troubleshooting

### API Key Issues
- Ensure API access is enabled in Organization Settings
- Verify the API key has not expired
- Check the key has appropriate permissions

### DNS Not Resolving
- Verify "Proxy to Upstream DNS" is enabled for the subnet
- Ensure the MX is running firmware 19.1 or later
- Confirm the network is not bound to a template

### Template Networks
- Local DNS via API is **not supported** for template-bound networks
- The API may return success but configuration won't apply

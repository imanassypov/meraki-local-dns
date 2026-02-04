# Bruno API Collection

> Interactive API collection for managing Meraki Local DNS via [Bruno](https://www.usebruno.com/).

## Overview

This Bruno collection provides a GUI-based approach to manage Local DNS profiles, records, and network assignments on Cisco Meraki MX appliances.

## Prerequisites

| Requirement | Details |
|-------------|---------|
| **Bruno** | [Download](https://www.usebruno.com/) or `brew install bruno` |
| **MX Firmware** | Version 19.1+ |
| **MX Mode** | NAT/Routed (not Passthrough) |
| **DHCP Setting** | "Proxy to Upstream DNS" enabled |
| **Network Type** | Non-Template (Templates not supported via API) |

## Installation

### 1. Install Bruno

```bash
# macOS
brew install bruno

# Or download from https://www.usebruno.com/
```

### 2. Open Collection

1. Launch Bruno
2. Click **Open Collection**
3. Navigate to this `bruno-collection` folder
4. Select the folder

### 3. Configure Environment

1. Click **Environments** in the sidebar
2. Select **Sandbox** (or create Production)
3. Fill in your values:

| Variable | Description | Example |
|----------|-------------|---------|
| `MERAKI_API_KEY` | Dashboard API key (mark as Secret) | `abc123...` |
| `organizationId` | Your organization ID | `123456` |
| `networkId` | Target MX network ID | `L_12345...` |
| `profileId` | DNS profile ID (after creation) | `68679...` |
| `recordId` | DNS record ID (after creation) | `68679...` |

4. Click **Save**

## Collection Structure

```
bruno-collection/
├── Profiles/
│   ├── Create Local DNS Profile.bru    # POST - Create new profile
│   ├── List Local DNS Profiles.bru     # GET  - List all profiles
│   └── Delete Local DNS Profile.bru    # DEL  - Remove a profile
├── Records/
│   ├── Create Local DNS Record.bru     # POST - Create hostname → IP mapping
│   ├── List Local DNS Records.bru      # GET  - List all records
│   └── Delete Local DNS Record.bru     # DEL  - Remove a record
├── Assignments/
│   ├── Assign Profile to Networks.bru  # POST - Link profile to network(s)
│   └── List Profile Assignments.bru    # GET  - List all assignments
└── environments/
    └── Sandbox.bru                     # Environment template
```

## Workflow

### Step 1: Create a DNS Profile

1. Navigate to **Profiles → Create Local DNS Profile**
2. Edit the request body:
   ```json
   {
     "name": "Internal DNS"
   }
   ```
3. Click **Send** (or `Cmd + Enter`)
4. Copy `profileId` from response → Update environment

### Step 2: Add DNS Records

1. Navigate to **Records → Create Local DNS Record**
2. Edit the request body:
   ```json
   {
     "hostname": "app.internal",
     "address": "10.1.1.100",
     "profile": {
       "id": "{{profileId}}"
     }
   }
   ```
3. Click **Send**
4. Repeat for additional records (max 1024 per MX)

### Step 3: Assign Profile to Network

1. Navigate to **Assignments → Assign Profile to Networks**
2. Verify `networkId` and `profileId` in the body
3. Click **Send**

### Verification

- Run **List Local DNS Profiles** to see all profiles
- Run **List Local DNS Records** to see all records
- Run **List Profile Assignments** to verify network linkage

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

## Tips

- **Query Parameters**: Enable optional filters by checking the checkbox next to `profileIds` in the Params tab
- **Inline Docs**: Click the **Docs** tab on any request for detailed documentation
- **Variables**: Use `{{variableName}}` syntax to reference environment variables

## Documentation

- [Local DNS on MX – Meraki Documentation](https://documentation.meraki.com/SASE_and_SD-WAN/MX/Operate_and_Maintain/How-Tos/Local_DNS_Service_on_MX)
- [Meraki Dashboard API Reference](https://developer.cisco.com/meraki/api-v1/)
- [Bruno Documentation](https://docs.usebruno.com/)

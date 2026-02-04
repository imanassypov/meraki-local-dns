# Copilot Instructions for Meraki Local DNS

## Project Overview
Bruno API collection for managing Local DNS records on Cisco Meraki MX appliances via the Dashboard API v1.

## Architecture
```
bruno-collection/
├── Profiles/          # DNS profile CRUD operations
├── Records/           # DNS record CRUD operations  
├── Assignments/       # Profile-to-network assignments
└── environments/      # Production & Sandbox configs
```

## API Base URL
`https://api.meraki.com/api/v1`

## Authentication
- Header: `X-Cisco-Meraki-API-Key: {{MERAKI_API_KEY}}`
- Store API key in Bruno environment as secret variable

## Key Endpoints
| Resource | Create | List | Delete |
|----------|--------|------|--------|
| Profiles | POST `.../dns/local/profiles` | GET | DELETE `.../{profileId}` |
| Records | POST `.../dns/local/records` | GET | DELETE `.../{recordId}` |
| Assignments | POST `.../assignments/bulkCreate` | GET | - |

## Prerequisites for Local DNS
- MX firmware 19.1+
- NAT/Routed Mode
- "Proxy to Upstream DNS" enabled (DHCP settings)
- Non-Template MX network (Templates not supported via API)

## Conventions
- All requests use `application/json` content type
- Environment variables: `organizationId`, `profileId`, `recordId`, `networkId`
- Maximum 1024 DNS records per MX device

## Workflow Pattern
1. Create DNS Profile → get `profileId`
2. Create DNS Records → associate with `profileId`
3. Assign Profile to Network(s) → link `profileId` + `networkId`

## Reference Documentation
- [Local DNS on MX](https://documentation.meraki.com/SASE_and_SD-WAN/MX/Operate_and_Maintain/How-Tos/Local_DNS_Service_on_MX)
- [API Reference](https://developer.cisco.com/meraki/api-v1/)

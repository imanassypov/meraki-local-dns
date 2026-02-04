# Meraki Local DNS

> Manage Local DNS records on Cisco Meraki MX appliances via the Dashboard API.

This repository provides two approaches for managing Local DNS on Meraki MX security appliances:

| Approach | Best For |
|----------|----------|
| [Bruno Collection](./bruno-collection/) | Interactive API exploration, GUI-based workflows |
| [Bash Scripts](./bash-scripts/) | Automation, CI/CD pipelines, command-line workflows |

## What is Local DNS on MX?

Local DNS allows the MX appliance to respond to DNS queries locally for configured domains. This is useful when:

- Using public DNS services (OpenDNS, Umbrella) for general queries
- Requiring local name resolution for internal resources
- Hosting private applications that need custom DNS entries

When a client queries a hostname configured in Local DNS, the MX responds directly. All other queries are forwarded to upstream DNS servers.

## Prerequisites

Before configuring Local DNS, ensure your environment meets these requirements:

| Requirement | Details |
|-------------|---------|
| **MX Firmware** | Version 19.1 or higher |
| **Operating Mode** | NAT/Routed Mode (not Passthrough) |
| **DHCP Settings** | "Proxy to Upstream DNS" enabled |
| **Network Type** | Non-Template MX network (Templates not supported via API) |

### Enable "Proxy to Upstream DNS"

1. Navigate to **Security & SD-WAN → Addressing & VLANs**
2. Select your VLAN or subnet
3. Under **DHCP Settings → DNS nameservers**, select **"Proxy to upstream DNS"**

## Quick Start

### Option 1: Bruno (GUI)

```bash
# Install Bruno
brew install bruno

# Open the collection
cd bruno-collection
# Open Bruno → Open Collection → Select this folder
```

See [Bruno Collection README](./bruno-collection/README.md) for detailed instructions.

### Option 2: Bash Scripts (CLI)

```bash
cd bash-scripts

# Configure credentials
cp config.env.example config.env
# Edit config.env with your API key and IDs

# Run complete setup
./setup-complete.sh "Internal DNS" "app.internal" "10.1.1.100"
```

See [Bash Scripts README](./bash-scripts/README.md) for detailed instructions.

## API Workflow

Local DNS configuration follows a three-step process:

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  1. Create      │     │  2. Add DNS     │     │  3. Assign to   │
│     Profile     │ ──► │     Records     │ ──► │     Network     │
└─────────────────┘     └─────────────────┘     └─────────────────┘
        │                       │                       │
   profileId               recordId              assignmentId
```

1. **Create Profile** – A named container for DNS records
2. **Create Records** – Hostname-to-IP mappings linked to the profile
3. **Assign Profile** – Link the profile to one or more MX networks

## API Endpoints

Base URL: `https://api.meraki.com/api/v1`

| Resource | Create | List | Delete |
|----------|--------|------|--------|
| Profiles | `POST /organizations/{orgId}/appliance/dns/local/profiles` | `GET` | `DELETE .../{profileId}` |
| Records | `POST /organizations/{orgId}/appliance/dns/local/records` | `GET` | `DELETE .../{recordId}` |
| Assignments | `POST .../profiles/assignments/bulkCreate` | `GET` | `POST .../bulkDelete` |

## Limits

- Maximum **1024 DNS records** per MX device

## Getting Your Credentials

### API Key

1. Log into [Meraki Dashboard](https://dashboard.meraki.com)
2. Navigate to **Organization → Settings**
3. Ensure **API Access** is enabled
4. Go to your profile (top-right) → **API Access**
5. Generate a new API key

### Organization ID

Find in the Dashboard URL:
```
https://dashboard.meraki.com/o/123456/...
                               ^^^^^^
                            Organization ID
```

### Network ID

Navigate to **Network-wide → General** and find the Network ID in the URL, or use the API:
```
GET /organizations/{orgId}/networks
```

## Documentation

### Cisco Meraki Official Documentation

- [Local DNS Service on MX](https://documentation.meraki.com/SASE_and_SD-WAN/MX/Operate_and_Maintain/How-Tos/Local_DNS_Service_on_MX) – Feature overview and prerequisites
- [Meraki Dashboard API Documentation](https://developer.cisco.com/meraki/api-v1/) – Complete API reference

### API Endpoint References

- [Create DNS Profile](https://developer.cisco.com/meraki/api-v1/create-organization-appliance-dns-local-profile/)
- [List DNS Profiles](https://developer.cisco.com/meraki/api-v1/get-organization-appliance-dns-local-profiles/)
- [Delete DNS Profile](https://developer.cisco.com/meraki/api-v1/delete-organization-appliance-dns-local-profile/)
- [Create DNS Record](https://developer.cisco.com/meraki/api-v1/create-organization-appliance-dns-local-record/)
- [List DNS Records](https://developer.cisco.com/meraki/api-v1/get-organization-appliance-dns-local-records/)
- [Delete DNS Record](https://developer.cisco.com/meraki/api-v1/delete-organization-appliance-dns-local-record/)
- [Assign Profiles to Networks](https://developer.cisco.com/meraki/api-v1/bulk-organization-appliance-dns-local-profiles-assignments-create/)
- [List Profile Assignments](https://developer.cisco.com/meraki/api-v1/get-organization-appliance-dns-local-profiles-assignments/)

## Troubleshooting

### DNS Not Resolving

1. Verify MX firmware is 19.1+ (**Organization → Firmware**)
2. Confirm "Proxy to Upstream DNS" is enabled in DHCP settings
3. Ensure the network is not bound to a template
4. Check that the profile is assigned to the correct network

### API Returns Success But No Effect

- Template-bound networks silently ignore API configuration
- Verify the MX is in NAT/Routed mode, not Passthrough

### Authentication Errors

- Ensure API access is enabled at the organization level
- Verify your API key has not expired
- Check the key has permissions for the target organization

## License

MIT

## Contributing

Contributions welcome! Please ensure no sensitive data (API keys, organization IDs) is included in commits.

# Bash Scripts

> Command-line scripts for managing Meraki Local DNS via the Dashboard API.

## Overview

These shell scripts provide a CLI-based approach to manage Local DNS profiles, records, and network assignments on Cisco Meraki MX appliances. Ideal for automation, scripting, and CI/CD pipelines.

## Prerequisites

| Requirement | Details |
|-------------|---------|
| **curl** | HTTP client (pre-installed on macOS/Linux) |
| **jq** | JSON processor – `brew install jq` |
| **MX Firmware** | Version 19.1+ |
| **MX Mode** | NAT/Routed (not Passthrough) |
| **DHCP Setting** | "Proxy to Upstream DNS" enabled |
| **Network Type** | Non-Template (Templates not supported via API) |

## Installation

### 1. Install Dependencies

```bash
# macOS
brew install jq

# Ubuntu/Debian
sudo apt-get install jq

# Verify
jq --version
```

### 2. Configure Credentials

```bash
cd bash-scripts

# Copy template
cp config.env.example config.env

# Edit with your values
nano config.env
```

**config.env:**
```bash
export MERAKI_API_KEY="your_api_key_here"
export ORGANIZATION_ID="123456"
export NETWORK_ID="L_123456789"
export PROFILE_ID=""   # Set after creating profile
export RECORD_ID=""    # Set after creating record
export BASE_URL="https://api.meraki.com/api/v1"
```

### 3. Make Scripts Executable

```bash
chmod +x *.sh
```

## Quick Start

Run the complete setup with a single command:

```bash
./setup-complete.sh "Internal DNS" "app.internal" "10.1.1.100"
```

This will:
1. Create a DNS profile named "Internal DNS"
2. Create a record mapping `app.internal` → `10.1.1.100`
3. Assign the profile to your configured network

## Scripts Reference

### Workflow Scripts (Numbered)

Run these in order for initial setup:

| Script | Description | Usage |
|--------|-------------|-------|
| `01-create-profile.sh` | Create a DNS profile | `./01-create-profile.sh "Profile Name"` |
| `02-create-record.sh` | Create a DNS record | `./02-create-record.sh "hostname" "ip"` |
| `03-assign-profile.sh` | Assign profile to network | `./03-assign-profile.sh` |

### List Scripts

Query existing configuration:

| Script | Description | Usage |
|--------|-------------|-------|
| `list-profiles.sh` | List all DNS profiles | `./list-profiles.sh` |
| `list-records.sh` | List all DNS records | `./list-records.sh [profileId]` |
| `list-assignments.sh` | List profile assignments | `./list-assignments.sh` |

### Delete Scripts

Remove configuration (with confirmation prompt):

| Script | Description | Usage |
|--------|-------------|-------|
| `delete-profile.sh` | Delete a profile | `./delete-profile.sh <profileId>` |
| `delete-record.sh` | Delete a record | `./delete-record.sh <recordId>` |

### All-in-One Script

| Script | Description | Usage |
|--------|-------------|-------|
| `setup-complete.sh` | Full setup in one command | `./setup-complete.sh "name" "host" "ip"` |

## Usage Examples

### Create Multiple Records

```bash
# Create profile
./01-create-profile.sh "Production DNS"
# Copy profileId from output to config.env

# Add records
./02-create-record.sh "app.internal" "10.1.1.100"
./02-create-record.sh "db.internal" "10.1.1.101"
./02-create-record.sh "cache.internal" "10.1.1.102"

# Assign to network
./03-assign-profile.sh
```

### List and Filter Records

```bash
# List all records
./list-records.sh

# Filter by profile ID
./list-records.sh 686798943174000641
```

### Delete a Record

```bash
# Get record ID from list
./list-records.sh

# Delete specific record (will prompt for confirmation)
./delete-record.sh 686798943174000641
```

## File Structure

```
bash-scripts/
├── config.env.example      # Template (committed to git)
├── config.env              # Your config (gitignored)
├── 01-create-profile.sh    # Step 1: Create profile
├── 02-create-record.sh     # Step 2: Create record
├── 03-assign-profile.sh    # Step 3: Assign to network
├── setup-complete.sh       # All-in-one setup
├── list-profiles.sh        # List profiles
├── list-records.sh         # List records
├── list-assignments.sh     # List assignments
├── delete-profile.sh       # Delete profile
├── delete-record.sh        # Delete record
└── README.md
```

## Output Format

All scripts output JSON formatted with `jq`. Example:

```json
{
  "profileId": "686798943174000641",
  "name": "Internal DNS"
}
```

## Error Handling

Scripts will:
- Exit on first error (`set -e`)
- Display error messages with ❌ prefix
- Show success messages with ✅ prefix
- Prompt for confirmation before deletions

## Documentation

- [Local DNS on MX – Meraki Documentation](https://documentation.meraki.com/SASE_and_SD-WAN/MX/Operate_and_Maintain/How-Tos/Local_DNS_Service_on_MX)
- [Meraki Dashboard API Reference](https://developer.cisco.com/meraki/api-v1/)
- [jq Manual](https://stedolan.github.io/jq/manual/)

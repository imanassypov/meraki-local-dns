# Meraki Local DNS - Bash Scripts

Shell scripts for managing Local DNS records on Cisco Meraki MX appliances.

## Prerequisites

- `curl` - HTTP client
- `jq` - JSON processor (install: `brew install jq`)
- Meraki API key with organization access

## Setup

1. Copy the example config:
   ```bash
   cp config.env.example config.env
   ```

2. Edit `config.env` with your values:
   ```bash
   export MERAKI_API_KEY="your_api_key"
   export ORGANIZATION_ID="443964"
   export NETWORK_ID="L_650207196201616147"
   ```

3. Make scripts executable:
   ```bash
   chmod +x *.sh
   ```

## Quick Start

Run the complete setup in one command:

```bash
./setup-complete.sh "Internal DNS" "www.example.local" "10.1.1.100"
```

## Individual Scripts

### Create Operations (numbered for workflow order)

| Script | Description |
|--------|-------------|
| `01-create-profile.sh` | Create a DNS profile |
| `02-create-record.sh` | Create a DNS record |
| `03-assign-profile.sh` | Assign profile to network |

### List Operations

| Script | Description |
|--------|-------------|
| `list-profiles.sh` | List all DNS profiles |
| `list-records.sh` | List all DNS records |
| `list-assignments.sh` | List profile assignments |

### Delete Operations

| Script | Description |
|--------|-------------|
| `delete-profile.sh` | Delete a DNS profile |
| `delete-record.sh` | Delete a DNS record |

## Usage Examples

```bash
# Create profile
./01-create-profile.sh "Production DNS"

# Create record (after setting PROFILE_ID in config.env)
./02-create-record.sh "app.internal" "192.168.1.50"

# Assign profile to network
./03-assign-profile.sh

# List all records
./list-records.sh

# Delete a specific record
./delete-record.sh "686798943174000641"
```

## File Structure

```
bash-scripts/
├── config.env.example    # Template config (safe to commit)
├── config.env            # Your config (gitignored)
├── 01-create-profile.sh  # Step 1: Create profile
├── 02-create-record.sh   # Step 2: Create record
├── 03-assign-profile.sh  # Step 3: Assign to network
├── setup-complete.sh     # All-in-one setup
├── list-profiles.sh      # List profiles
├── list-records.sh       # List records
├── list-assignments.sh   # List assignments
├── delete-profile.sh     # Delete profile
└── delete-record.sh      # Delete record
```

# Cerebrium APT Repository

Official APT repository for Cerebrium CLI packages.

## Installation

Add the GPG key:
```bash
curl -fsSL https://cerebriumai.github.io/cerebrium-apt/cerebrium.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cerebrium-keyring.gpg
```

Add the repository:
```bash
echo "deb [signed-by=/usr/share/keyrings/cerebrium-keyring.gpg] https://cerebriumai.github.io/cerebrium-apt/ stable main" | sudo tee /etc/apt/sources.list.d/cerebrium.list
```

Install Cerebrium:
```bash
sudo apt update
sudo apt install cerebrium
```

## Supported Architectures
- amd64 (x86_64)
- arm64 (aarch64)

## Repository Maintenance
- `update-repo.sh` - Regenerate repository metadata
- `add-package.sh` - Add a new .deb package

## GPG Key
- Key ID: 61E31EFB9CDC52C1
- Valid until: 2027-11-20

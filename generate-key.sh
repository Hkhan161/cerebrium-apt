#!/bin/bash
# Check if GPG key already exists
if gpg --list-secret-keys --keyid-format=long | grep -q "Cerebrium APT Repository"; then
  echo "GPG key already exists for Cerebrium APT Repository"
  KEY_ID=$(gpg --list-secret-keys --keyid-format=long | grep -A1 "Cerebrium APT Repository" | grep "sec" | awk '{print $2}' | cut -d'/' -f2)
  echo "Key ID: $KEY_ID"
else
  echo "Generating new GPG key..."
  gpg --batch --generate-key <<KEY_CONFIG
%echo Generating GPG key for Cerebrium APT Repository
Key-Type: RSA
Key-Length: 4096
Subkey-Type: RSA
Subkey-Length: 4096
Name-Real: Cerebrium Inc
Name-Email: apt@cerebrium.ai
Name-Comment: Cerebrium APT Repository
Expire-Date: 2y
%no-protection
%commit
KEY_CONFIG
  KEY_ID=$(gpg --list-secret-keys --keyid-format=long | grep -A1 "Cerebrium APT Repository" | grep "sec" | awk '{print $2}' | cut -d'/' -f2)
  echo "Generated new key: $KEY_ID"
fi

# Export public key
gpg --armor --export $KEY_ID > cerebrium.gpg
echo "Public key exported to cerebrium.gpg"

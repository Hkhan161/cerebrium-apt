#!/bin/bash
# Test APT installation in Docker

docker run --rm -it ubuntu:22.04 bash -c "
apt-get update && apt-get install -y curl gnupg

# Add GPG key
curl -fsSL https://cerebriumai.github.io/cerebrium-apt/cerebrium.gpg | gpg --dearmor -o /usr/share/keyrings/cerebrium-keyring.gpg

# Add repository
echo \"deb [signed-by=/usr/share/keyrings/cerebrium-keyring.gpg] https://cerebriumai.github.io/cerebrium-apt/ stable main\" | tee /etc/apt/sources.list.d/cerebrium.list

# Update and show available package
apt-get update
apt-cache search cerebrium
apt-cache show cerebrium
"

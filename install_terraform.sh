#!/bin/bash

# Exit on error
set -e

echo "[+] Updating system and installing dependencies..."
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl

echo "[+] Adding HashiCorp GPG key..."
curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

# Detect Ubuntu codename
UBUNTU_CODENAME=$(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs)

echo "[+] Adding HashiCorp APT repository..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $UBUNTU_CODENAME main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

echo "[+] Updating APT and installing Terraform..."
sudo apt update && sudo apt-get install -y terraform

echo "[✓] Terraform installation completed successfully!"
terraform version

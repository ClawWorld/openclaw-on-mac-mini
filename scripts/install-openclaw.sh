#!/bin/bash
set -e

echo "Starting OpenClaw installation..."

# Update system
apt-get update
apt-get install -y curl git nodejs npm

# Install Node.js if not already installed (using NodeSource)
if ! command -v node --version &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_24.x | bash -
    apt-get install -y nodejs
fi

# Verify Node.js version
echo "Node.js version: $(node --version)"
echo "NPM version: $(npm --version)"

# Install OpenClaw globally
npm install -g openclaw

# Create the OpenClaw workspace directory
mkdir -p /home/vagrant/.openclaw/workspace

# Initialize OpenClaw in the workspace
cd /home/vagrant/.openclaw/workspace
sudo -u vagrant -H sh -c "openclaw init"

# Set up proper permissions
chown -R vagrant:vagrant /home/vagrant/.openclaw

# Enable systemd for services (this will be handled by Vagrant)
echo "OpenClaw installation completed."
# Alternative Approach: Docker-Based OpenClaw Environment

Due to network constraints preventing the installation of Packer plugins, here's an alternative approach to create an OpenClaw development environment for ARM64:

## Option 1: Using Docker (Recommended for this environment)

Create a Dockerfile that sets up Debian 12 with OpenClaw:

```Dockerfile
FROM debian:bookworm-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    nodejs \
    npm \
    sudo \
    openssh-server \
    && rm -rf /var/lib/apt/lists/*

# Install OpenClaw
RUN npm install -g openclaw

# Create vagrant user (for consistency with original plan)
RUN useradd -m -s /bin/bash vagrant && \
    echo 'vagrant:vagrant' | chpasswd && \
    echo 'vagrant ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/vagrant

# Create workspace
RUN mkdir -p /home/vagrant/.openclaw/workspace
RUN chown -R vagrant:vagrant /home/vagrant/.openclaw

EXPOSE 3000

WORKDIR /home/vagrant/.openclaw/workspace

CMD ["sleep", "infinity"]
```

## Option 2: Manual Setup Guide

If you still want to use the original Packer approach:

1. On your local Mac Mini, install Packer:
   ```bash
   brew install packer
   ```

2. Clone the project:
   ```bash
   git clone <repository-url>
   cd openclaw-arm64-packer
   ```

3. Install the QEMU plugin:
   ```bash
   packer plugins install github.com/hashicorp/qemu
   ```

4. Build the image:
   ```bash
   packer build packer-template.json
   ```

5. Package as Vagrant box:
   ```bash
   vagrant package --output openclaw-debian-bookworm-arm64.box output-debian-12-arm64/
   ```

6. Add to Vagrant:
   ```bash
   vagrant box add openclaw-debian-bookworm-arm64 openclaw-debian-bookworm-arm64.box
   ```

## Option 3: Direct Installation on Mac

You can also install OpenClaw directly on your Mac Mini:

```bash
# Install Node.js if not already installed
brew install node

# Install OpenClaw
npm install -g openclaw

# Initialize OpenClaw
mkdir -p ~/openclaw-workspace
cd ~/openclaw-workspace
openclaw init
```

## Current Status

The files created for the Packer/Vagrant approach are already in place:
- Packer template: `packer-template.json`
- Provisioning script: `scripts/install-openclaw.sh`
- Preseed file: `preseed.cfg`
- Vagrantfile: `Vagrantfile`
- Documentation: `BUILD-INSTRUCTIONS.md`

However, the Packer build cannot proceed due to network constraints preventing the QEMU plugin installation.
# OpenClaw ARM64 Packer Build

This project creates a Vagrant box for OpenClaw using Packer with Debian 12 (Bookworm) ARM64 base image.

## Prerequisites

- Packer (installed)
- VirtualBox or QEMU/KVM for building
- Vagrant for testing the final box
- At least 8GB free disk space
- Internet connection for downloads

## Building the Box

### Option 1: Using Make (recommended)

```bash
# Validate the Packer template
make validate

# Build the box (this will take some time)
make build

# Export as Vagrant box
make export-box

# Or do both in one command
make build-and-export
```

### Option 2: Using Packer directly

For JSON format:
```bash
# Validate the template
packer validate packer-template.json

# Build the box
packer build packer-template.json
```

For HCL format (preferred):
```bash
# Validate the template
packer validate packer-template.pkr.hcl

# Build the box
packer build packer-template.pkr.hcl
```

Note: The HCL format (packer-template.pkr.hcl) is the newer, recommended format for Packer templates.

## Using the Vagrant Box

After building and exporting:

1. Add the box to Vagrant:
   ```bash
   vagrant box add --force openclaw-debian-bookworm-arm64 openclaw-debian-bookworm-arm64_0.1.0.box
   ```

2. Create a new directory for your Vagrant environment:
   ```bash
   mkdir openclaw-vm && cd openclaw-vm
   ```

3. Initialize and start the VM:
   ```bash
   vagrant init openclaw-debian-bookworm-arm64
   vagrant up
   ```

4. Access the VM:
   ```bash
   vagrant ssh
   ```

## Customization

You can customize the build by setting environment variables:

- `PACKER_CPUS`: Number of CPUs (default: 2)
- `PACKER_MEMORY`: RAM in MB (default: 4096)

Example:
```bash
PACKER_CPUS=4 PACKER_MEMORY=8192 packer build packer-template.json
```

## Troubleshooting

- If the build fails during the ISO download, ensure you have a stable internet connection
- If SSH connection fails during provisioning, increase the timeout in the template
- For QEMU-specific issues, ensure KVM acceleration is available

## Notes

- The final image includes OpenClaw pre-installed
- The default user is `vagrant` with password `vagrant`
- SSH keys are pre-configured for Vagrant
- The image is optimized for ARM64 Mac Mini systems
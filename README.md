# OpenClaw ARM64 Packer Build

This project creates a Vagrant box for OpenClaw using Packer with Debian 12 (Bookworm) ARM64 base image.

## Project Structure
- `packer-template.json` - Packer build configuration for Debian 12 ARM64
- `packer-template.pkr.hcl` - Packer build configuration for Debian 12 ARM64 (HCL format)
- `scripts/install-openclaw.sh` - Provisioning script for OpenClaw
- `preseed.cfg` - Debian installation automation file
- `Vagrantfile` - Vagrant configuration for deployment
- `Makefile` - Build automation commands
- `BUILD-INSTRUCTIONS.md` - Detailed build instructions
- `ALTERNATIVE-APPROACHES.md` - Alternative methods to set up the environment
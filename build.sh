#!/bin/bash

set -e  # Exit on any error

echo "==========================================="
echo "OpenClaw ARM64 Vagrant Box Builder"
echo "==========================================="

# Check if required tools are available
echo "Checking prerequisites..."

if ! command -v packer &> /dev/null; then
    echo "Error: Packer is not installed or not in PATH"
    exit 1
fi

if ! command -v vagrant &> /dev/null; then
    echo "Warning: Vagrant is not installed - you won't be able to test the box"
fi

echo "✓ Packer is available"
echo "Packer version: $(packer version)"

# Validate the template
echo ""
echo "Validating Packer template..."
packer validate packer-template.json
echo "✓ Template validation passed"

# Create output directories if they don't exist
mkdir -p output

# Build the box
echo ""
echo "Starting build process..."
echo "This may take 15-30 minutes depending on your system and internet speed"
echo ""

packer build -force packer-template.json

echo ""
echo "Build completed successfully!"
echo ""
echo "Next steps:"
echo "1. Check the output directory for your built image"
echo "2. To package as a Vagrant box, run: vagrant package --output openclaw-debian-bookworm-arm64.box output-[...]/"
echo "3. To add to Vagrant: vagrant box add openclaw-debian-bookworm-arm64 openclaw-debian-bookworm-arm64.box"
echo "4. To use: vagrant init openclaw-debian-bookworm-arm64 && vagrant up"
echo ""
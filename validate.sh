#!/bin/bash

# Validation script for OpenClaw ARM64 Packer project
# Since network restrictions prevent plugin installation, this script validates JSON syntax and general structure

echo "==========================================="
echo "OpenClaw ARM64 Packer Project Validator"
echo "==========================================="

echo ""
echo "Validating JSON syntax..."
if command -v python3 &> /dev/null; then
    if python3 -m json.tool packer-template.json >/dev/null 2>&1; then
        echo "✓ packer-template.json is valid JSON"
    else
        echo "✗ packer-template.json has invalid JSON syntax"
        exit 1
    fi
else
    echo "! Python3 not available, skipping JSON validation"
fi

echo ""
echo "Checking required files..."
files=(
    "packer-template.json"
    "packer-template.pkr.hcl"
    "scripts/install-openclaw.sh"
    "preseed.cfg"
    "Vagrantfile"
    "Makefile"
    "README.md"
)

missing_files=()
for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "✓ $file exists"
    else
        echo "✗ $file missing"
        missing_files+=("$file")
    fi
done

if [ ${#missing_files[@]} -ne 0 ]; then
    echo ""
    echo "Error: Missing required files: ${missing_files[*]}"
    exit 1
fi

echo ""
echo "Checking executables..."
if [ -x "scripts/install-openclaw.sh" ]; then
    echo "✓ scripts/install-openclaw.sh is executable"
else
    echo "! scripts/install-openclaw.sh is not executable, fixing..."
    chmod +x scripts/install-openclaw.sh
fi

if [ -x "build.sh" ]; then
    echo "✓ build.sh is executable"
else
    echo "! build.sh is not executable, fixing..."
    chmod +x build.sh
fi

echo ""
echo "Validation completed successfully!"
echo ""
echo "Note: Full Packer validation cannot be performed due to network restrictions"
echo "preventing the installation of required plugins (QEMU)."
echo ""
echo "To complete the build, transfer these files to a system with network access"
echo "and run: packer plugins install github.com/hashicorp/qemu"
echo "followed by: packer build packer-template.pkr.hcl"
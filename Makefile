.PHONY: build validate clean

# Variables
BOX_NAME = openclaw-debian-bookworm-arm64
BOX_VERSION = 0.1.0
CURRENT_DIR = $(shell pwd)

# Validate the Packer template
validate:
	packer validate packer-template.json

# Build the Vagrant box
build: validate
	@echo "Building Vagrant box: $(BOX_NAME)_$(BOX_VERSION).box"
	packer build -force packer-template.json
	@echo "Build completed. Box file created."

# Clean up build artifacts
clean:
	rm -rf output-*
	rm -f *.box

# Export as Vagrant box
export-box:
	@echo "Exporting as Vagrant box..."
	@if [ -d "output-debian-12-arm64" ]; then \
		cd output-debian-12-arm64 && \
		vagrant package --output ../$(BOX_NAME)_$(BOX_VERSION).box . && \
		echo "Vagrant box created: $(BOX_NAME)_$(BOX_VERSION).box"; \
	else \
		echo "Error: output directory not found. Run 'make build' first."; \
	fi

# Combined build and export
build-and-export: build export-box

# Add the box to Vagrant
add-box:
	vagrant box add --force $(BOX_NAME) $(BOX_NAME)_$(BOX_VERSION).box

# Initialize Vagrant environment
init-vagrant:
	vagrant init $(BOX_NAME)
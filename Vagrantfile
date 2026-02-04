# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Base box
  config.vm.box = "openclaw-debian-bookworm-arm64"
  
  # Provider settings
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.cpus = 2
    vb.memory = "4096"
    vb.name = "openclaw-arm64"
  end
  
  config.vm.provider "libvirt" do |lv|
    lv.cpus = 2
    lv.memory = 4096
    lv.driver = "kvm"
    lv.nested = true
  end

  # Network configuration
  config.vm.network "private_network", type: "dhcp"
  
  # Synced folders
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder "~/openclaw-workspace", "/home/vagrant/.openclaw/workspace", create: true

  # Port forwarding for OpenClaw
  config.vm.network "forwarded_port", guest: 3000, host: 3000, protocol: "tcp" # Web interface
  config.vm.network "forwarded_port", guest: 8080, host: 8080, protocol: "tcp" # Alternative port
  config.vm.network "forwarded_port", guest: 9000, host: 9000, protocol: "tcp" # Dev tools

  # Configure SSH
  config.ssh.username = "vagrant"
  config.ssh.password = "vagrant"
  config.ssh.insert_key = false

  # Provisioning (only runs on first up)
  config.vm.provision "shell", inline: <<-SHELL
    echo "Ensuring OpenClaw environment is ready..."
    
    # Ensure the workspace directory exists
    mkdir -p /home/vagrant/.openclaw/workspace
    chown -R vagrant:vagrant /home/vagrant/.openclaw
    
    # Start OpenClaw service if available
    if command -v openclaw &> /dev/null; then
      echo "OpenClaw is installed and ready!"
      
      # Initialize OpenClaw if not already initialized
      cd /home/vagrant/.openclaw/workspace
      if [ ! -f ".openclaw-initialized" ]; then
        sudo -u vagrant -H sh -c "openclaw init"
        touch .openclaw-initialized
      fi
    else
      echo "OpenClaw installation appears to be missing."
    fi
    
    # Install common development tools
    apt-get update
    apt-get install -y build-essential jq htop iotop sysstat
    
    # Set up bash aliases
    echo 'alias claw="openclaw"' >> /home/vagrant/.bashrc
    echo 'alias ll="ls -la"' >> /home/vagrant/.bashrc
    
    echo "Setup complete! You can now access your OpenClaw environment."
    echo "To start OpenClaw: sudo -u vagrant -H sh -c 'openclaw start'"
  SHELL
end
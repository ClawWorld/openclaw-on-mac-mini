variable "debian_version" {
  type    = string
  default = "12"
}

variable "box_name" {
  type    = string
  default = "openclaw-debian-bookworm-arm64"
}

variable "cpus" {
  type    = string
  default = "2"
}

variable "memory" {
  type    = string
  default = "4096"
}

source "qemu" "debian_arm64" {
  vm_name           = var.box_name
  iso_url           = "https://cdimage.debian.org/debian-cd/current/arm64/iso-cd/debian-12-generic-arm64-netinst.iso"
  iso_checksum      = "file:https://cdimage.debian.org/debian-cd/current/arm64/iso-cd/SHA256SUMS"
  output_directory  = "output-debian-${var.debian_version}-arm64"
  shutdown_command  = "echo 'vagrant' | sudo -S shutdown -h now"
  ssh_username      = "vagrant"
  ssh_password      = "vagrant"
  ssh_port          = 22
  ssh_wait_timeout  = "10000s"
  communicator      = "ssh"
  
  boot_command = [
    "<esc><wait>",
    "install <wait>",
    " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg <wait>",
    "debian-installer/locale=en_US.UTF-8 <wait>",
    "kbd-chooser/method=us <wait>",
    "keyboard-configuration/xkb-keymap=us <wait>",
    "netcfg/get_hostname=openclaw-debian-bookworm-arm64 <wait>",
    "netcfg/get_domain=vagrantup.com <wait>",
    "fb=false <wait>",
    "debconf/frontend=noninteractive <wait>",
    "console-setup/ask_detect=false <wait>",
    "console-keymaps-at/keymap=us <wait>",
    "<enter><wait>"
  ]
  
  boot_wait     = "5s"
  disk_size     = 10000
  format        = "qcow2"
  headless      = true
  machine_type  = "virt"
  net_device    = "virtio-net"
  disk_interface = "virtio"
  memory        = var.memory
  cpus          = var.cpus
}

build {
  name = "openclaw-debian-bookworm-arm64-build"
  sources = [
    "source.qemu.debian_arm64"
  ]

  provisioner "shell" {
    inline = [
      "echo 'vagrant ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/vagrant",
      "sed -i 's/^%sudo.*/%sudo ALL=(ALL:ALL) NOPASSWD:ALL/' /etc/sudoers",
      "mkdir -p /home/vagrant/.ssh",
      "wget --no-check-certificate 'https://raw.githubusercontent.com/hashicorp/vagrant/main/keys/vagrant.pub' -O /home/vagrant/.ssh/authorized_keys",
      "chmod 0600 /home/vagrant/.ssh/authorized_keys",
      "chown -R vagrant:vagrant /home/vagrant/.ssh",
      "echo 'UseDNS no' >> /etc/ssh/sshd_config",
      "echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config"
    ]
  }

  provisioner "shell" {
    script = "scripts/install-openclaw.sh"
  }
}
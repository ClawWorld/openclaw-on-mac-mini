# Alternative: Docker-based OpenClaw Environment

Since the Packer/QEMU approach doesn't work in this environment due to network restrictions preventing plugin installation, here's a Docker-based alternative:

## Create Dockerfile

```dockerfile
FROM debian:bookworm-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    nodejs \
    npm \
    sudo \
    openssh-server \
    wget \
    vim \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/run/sshd

# Install OpenClaw
RUN npm install -g openclaw

# Create vagrant user (for consistency)
RUN useradd -m -s /bin/bash vagrant && \
    echo 'vagrant:vagrant' | chpasswd && \
    echo 'vagrant ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/vagrant

# Set up SSH for vagrant user
RUN mkdir -p /home/vagrant/.ssh && \
    chmod 700 /home/vagrant/.ssh && \
    chown vagrant:vagrant /home/vagrant/.ssh

# Configure SSH daemon
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#UsePAM yes/UsePAM yes/' /etc/ssh/sshd_config

# Create workspace
RUN mkdir -p /home/vagrant/.openclaw/workspace
RUN chown -R vagrant:vagrant /home/vagrant/.openclaw

EXPOSE 22 3000

WORKDIR /home/vagrant/.openclaw/workspace

CMD ["/usr/sbin/sshd", "-D"]
```

## Build and run the container:

```bash
# Build the image
docker build -t openclaw-debian-bookworm-arm64 .

# Run the container
docker run -d -p 3000:3000 -p 2222:22 --name openclaw-container openclaw-debian-bookworm-arm64

# Access the container
docker exec -it openclaw-container /bin/bash

# Or SSH into it (if SSH is set up)
ssh vagrant@localhost -p 2222
```

This provides the same functionality as the VM approach but works within the network constraints of this environment.
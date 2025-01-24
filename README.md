# F5 VPN Docker Desktop Environment

A containerized Ubuntu desktop environment with F5 VPN client pre-installed, accessible via Remote Desktop Protocol (RDP). This solution provides a lightweight, isolated environment for connecting to F5 VPN networks without affecting your host system.

## Overview

This project creates a Docker container running:
- Ubuntu 20.04 with XFCE4 desktop environment
- XRDP server for remote desktop access
- GoF5 (open-source F5 VPN client)
- Persistent storage for user data

## Prerequisites

- Podaman Desktop,Docker Desktop (Windows/Mac) or Docker Engine (Linux)
- Remote Desktop Client
  - Windows: Built-in Remote Desktop Connection
  - MacOS: Microsoft Remote Desktop (App Store)
  - Linux: Remmina or similar RDP client

## Quick Start

1. Clone the repository:
```
git clone https://github.com/your-username/f5vpn-docker-desktop.git
cd f5vpn-docker-desktop
```

2. Start the container:
```
docker compose up -d
```

3. Connect via RDP:
   - Connect to: `localhost:3389`
   - Username: `ubuntu`
   - Password: `ubuntu`

4. Launch VPN (in container's terminal):
```
gof5 --server <VPN_SERVER> --username <USER> --passwd <PASSWORD>
```

## Installation Guide

### Windows Setup

1. Install Docker Desktop
   - Download from [Docker Hub](https://hub.docker.com/editions/community/docker-ce-desktop-windows)
   - Enable WSL 2 when prompted during installation
   - Restart your computer

2. Start Container
   ```
   docker compose up -d
   ```

3. Connect
   - Press Win + R
   - Type `mstsc`
   - Enter `localhost:3389`
   - Use credentials above

### MacOS Setup

1. Install Docker Desktop
   - Download from [Docker Hub](https://hub.docker.com/editions/community/docker-ce-desktop-mac)
   - Complete installation and start Docker Desktop

2. Install Microsoft Remote Desktop
   - Download from Mac App Store
   - Launch Microsoft Remote Desktop
   - Add new connection to `localhost:3389`

3. Start Container
   ```
   docker compose up -d
   ```

### Linux Setup

1. Install Docker and Docker Compose:
```
# Ubuntu/Debian
sudo apt update
sudo apt install docker.io docker-compose

# Start and enable Docker
sudo systemctl start docker
sudo systemctl enable docker

# Add your user to docker group (logout/login required after)
sudo usermod -aG docker $USER
```

2. Install RDP Client:
```
# Ubuntu/Debian
sudo apt install remmina

# Fedora
sudo dnf install remmina
```

3. Start Container:
```
docker compose up -d
```

## Project Structure
```
f5vpn-docker-desktop/
├── docker-compose.yml      # Container orchestration
├── f5vpn-desktop/         # Desktop environment files
│   └── Dockerfile         # Container build instructions
└── README.md              # This file
```

## Common Operations

### Start Container
```
docker compose up -d
```

### Stop Container
```
docker compose down
```

### View Logs
```
docker logs f5vpn-desktop
```

### Rebuild Container
```
docker compose up -d --build
```

## Troubleshooting

### Cannot Connect via RDP
1. Verify container is running:
```
docker ps | grep f5vpn-desktop
```

2. Check container logs:
```
docker logs f5vpn-desktop
```

3. Verify port availability:
```
# Windows (PowerShell)
Test-NetConnection -ComputerName localhost -Port 3389

# Linux/MacOS
nc -zv localhost 3389
```

### VPN Connection Issues
1. Ensure container has proper privileges:
   - Check `privileged: true` in docker-compose.yml

2. Verify VPN server accessibility:
```
ping <VPN_SERVER>
```

## Security Notes

- Default credentials should be changed for production use
- Container runs in privileged mode for VPN functionality
- Data persists in Docker volume `f5vpn-home`

## Maintenance

To update the environment:
1. Pull latest changes:
```
git pull origin main
```

2. Rebuild and restart:
```
docker compose down
docker compose up -d --build
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

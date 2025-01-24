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
git clone https://github.com/digitalis-io/docker-compose-ubuntu-desktop-f5-client.git
cd f5vpn-docker-desktop
```

2. Start the container:
```
podman compose up -d
```
or
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

1. Install [Podman Desktop](https://podman.io) or [Docker Desktop](https://docker.com)

2. Start Container
   ```
   podman compose up -d
   ```
or
   ```
   docker compose up -d
   ```

3. Connect
   - Press Win + R
   - Type `mstsc`
   - Enter `localhost:3389`
   - Use credentials above

### MacOS Setup

1. Install [Podman Desktop](https://podman.io) or [Docker Desktop](https://docker.com)

2. Install Microsoft Remote Desktop
   - Download from Mac App Store
   - Launch Microsoft Remote Desktop
   - Add new connection to `localhost:3389`

3. Start Container
   ```
   docker compose up -d
   ```

### Linux Setup

1. Install Podman and Podman Compose or Docker and Docker Compose:

2. Install RDP Client:
```
# Ubuntu/Debian
sudo apt install remmina

# Fedora
sudo dnf install remmina
```

3. Start Container:
```
podman compose up -d
```
or
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
podman compose up -d
```

### Stop Container
```
podman compose down
```

### View Logs
```
podman logs f5vpn-desktop
```

### Rebuild Container
```
podman compose up -d --build
```

## Troubleshooting

### Cannot Connect via RDP
1. Verify container is running:
```
podman ps | grep f5vpn-desktop
```

2. Check container logs:
```
podman logs f5vpn-desktop
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
podman compose down
podman compose up -d --build
```


## License
This project is licensed under the Apache License 2.0 - see below for details.

Copyright 2025 Digitalis.io Ltd

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

***
This project may contain trademarks or logos for projects, products, or services. Any use of third-party trademarks or logos are subject to those third-party's policies. 

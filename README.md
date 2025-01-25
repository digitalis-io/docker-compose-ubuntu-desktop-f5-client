## Overview

This repository contains a Docker/Podman-based setup for running an Ubuntu 22.04 desktop (XFCE) with XRDP, Visual Studio Code, Git, SSH server, and an F5 VPN client (gof5). It was built and tested on an Apple Silicon (arm64) Mac using Podman. It may or may not work on other platforms.

This project credits inspiration and guidance from [danchitnis/container-xrdp](https://github.com/danchitnis/container-xrdp).

![output](https://github.com/user-attachments/assets/edef236d-41eb-4460-b1c0-814fd3717f3e)

## Features

- **XRDP** for remote desktop access via RDP  
- **XFCE desktop** for a lightweight GUI  
- **SSH server** for secure shell access  
- **Visual Studio Code** installed via Microsoft’s apt repository  
- **Git** for version control  
- **F5 VPN client (gof5)** for VPN connectivity  

## Requirements

- **Podman** (or Docker)  
- **Apple Silicon Mac** (arm64) – tested on macOS with Apple M-series  
- **RDP client** (e.g., Microsoft “Windows App” Remote Desktop on macOS)

## Getting Started

1. **Clone or download** this repository.  
2. **Build** the container:  
   ```bash
   podman compose build
   ```
   or (if your system supports Docker Compose):
   ```bash
   docker compose build
   ```

3. **Run** the container in the background, mapping RDP and SSH ports:
   ```bash
   podman compose up -d
   ```
   By default, RDP is exposed on port 3389 and SSH on port 2222 (depending on your configuration).

4. **Default credentials**:  
   - Username: `admin`  
   - Password: `admin`

## Connecting via RDP on macOS

1. **Install the “Windows App”** (Microsoft Remote Desktop) from the Mac App Store if you haven’t already.  
2. **Open** the Microsoft Remote Desktop app.  
3. **Add a new connection**:  
   - **PC name**: `localhost:3389`  
   - **User account**: If prompted, enter username `admin` and password `admin`.  
4. **Connect**. Wait a few seconds on the black screen while the XFCE desktop initializes.  

Once the desktop appears, you can launch Visual Studio Code or use Git on the container’s terminal.

## SSH Access

1. **Open a terminal** on your Mac.  
2. **Connect** via SSH (replace with `docker` if you’re using Docker):
   ```bash
   ssh -p 2222 admin@localhost
   ```
   Enter the password `admin`.  

## Using the F5 VPN Client (gof5)

The open-source F5 VPN client, **gof5**, is installed at `/usr/local/bin/gof5`.  
1. **In a terminal** (RDP or SSH), run something like:
   ```bash
   gof5 --server <YOUR_F5_SERVER> --username <YOUR_USERNAME> --passwd <YOUR_PASSWORD>
   ```
2. For more info and advanced usage, see the official [gof5 documentation](https://github.com/kayrus/gof5).

## Credits

- **XRDP setup** based in part on ideas from [danchitnis/container-xrdp](https://github.com/danchitnis/container-xrdp).

## Caveats

- This project was **only tested on an Apple Silicon Mac** using Podman. It might not work on other CPU architectures or operating systems without tweaks.  
- If you see issues with Snap-based packages, or if you need additional capabilities, you may need to run podman or docker in privileged mode.  
- The default credentials (`admin:admin`) are for demonstration. Change them before exposing your container to untrusted networks.

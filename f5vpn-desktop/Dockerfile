FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install basic packages and Ubuntu desktop environment + XRDP server
RUN apt-get update && apt-get install -y --no-install-recommends \
    ubuntu-desktop \
    ubuntu-gnome-desktop \
    xrdp \
    wget \
    apt-transport-https \
    ca-certificates \
    gnupg2 \
    sudo \
    software-properties-common \
    curl \
    git \
    vim \
    openssh-server && \
    rm -rf /var/lib/apt/lists/*

# Install VS Code
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg && \
    install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg && \
    sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list' && \
    rm -f packages.microsoft.gpg && \
    apt-get update && \
    apt-get install -y code && \
    rm -rf /var/lib/apt/lists/*

# Create a non-root user for the desktop session
RUN useradd -m -s /bin/bash ubuntu && \
    echo "ubuntu:ubuntu" | chpasswd && \
    adduser ubuntu sudo

# Configure XRDP
RUN sed -i 's/3389/3389/g' /etc/xrdp/xrdp.ini && \
    sed -i 's/max_bpp=32/#max_bpp=32\nmax_bpp=128/g' /etc/xrdp/xrdp.ini && \
    sed -i 's/xserverbpp=24/#xserverbpp=24\nxserverbpp=128/g' /etc/xrdp/xrdp.ini && \
    systemctl enable xrdp

# Configure default session for GNOME
RUN echo "[Allow Colord all Users]" >> /etc/polkit-1/localauthority.conf.d/02-allow-colord.conf && \
    echo "Identity=unix-user:*" >> /etc/polkit-1/localauthority.conf.d/02-allow-colord.conf && \
    echo "Action=org.freedesktop.color-manager.create-device;org.freedesktop.color-manager.create-profile;org.freedesktop.color-manager.delete-device;org.freedesktop.color-manager.delete-profile;org.freedesktop.color-manager.modify-device;org.freedesktop.color-manager.modify-profile" >> /etc/polkit-1/localauthority.conf.d/02-allow-colord.conf && \
    echo "ResultAny=no" >> /etc/polkit-1/localauthority.conf.d/02-allow-colord.conf && \
    echo "ResultInactive=no" >> /etc/polkit-1/localauthority.conf.d/02-allow-colord.conf && \
    echo "ResultActive=yes" >> /etc/polkit-1/localauthority.conf.d/02-allow-colord.conf

# Download and install gof5 (an open source F5 VPN client)
RUN wget https://github.com/kayrus/gof5/releases/download/v0.1.4/gof5_linux_amd64 && \
    chmod +x gof5_linux_amd64 && \
    mv gof5_linux_amd64 /usr/local/bin/gof5 && \
    setcap cap_net_admin,cap_net_bind_service+ep /usr/local/bin/gof5 && \
    echo "[Allow Colord all Users]\nIdentity=unix-user:*\nAction=org.freedesktop.resolve1.manage\nResultAny=yes\nResultInactive=yes\nResultActive=yes" > /etc/polkit-1/localauthority/50-local.d/org.freedesktop.resolve1.pkla

# Configure SSH
# RUN mkdir -p /var/run/sshd && \
#     mkdir -p /etc/ssh && \
#     echo 'Port 22' >> /etc/ssh/sshd_config && \
#     echo 'Protocol 2' >> /etc/ssh/sshd_config && \
#     echo 'PermitRootLogin no' >> /etc/ssh/sshd_config && \
#     echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config && \
#     echo 'UsePAM yes' >> /etc/ssh/sshd_config && \
#     echo 'X11Forwarding yes' >> /etc/ssh/sshd_config && \
#     echo 'PrintMotd no' >> /etc/ssh/sshd_config && \
#     echo 'AcceptEnv LANG LC_*' >> /etc/ssh/sshd_config && \
#     echo 'Subsystem sftp /usr/lib/openssh/sftp-server' >> /etc/ssh/sshd_config

EXPOSE 3389 22

# Start both XRDP and SSH services
CMD service ssh start && /usr/sbin/xrdp -n

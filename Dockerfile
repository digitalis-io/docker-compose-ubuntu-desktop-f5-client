FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 1. Basic setup
RUN apt-get update && apt-get -y upgrade

# 2. Install packages for XFCE, XRDP, SSH, etc.
RUN apt-get install -y \
    xfce4 \
    xfce4-clipman-plugin \
    xfce4-cpugraph-plugin \
    xfce4-netload-plugin \
    xfce4-screenshooter \
    xfce4-taskmanager \
    xfce4-terminal \
    xfce4-xkb-plugin \
    dbus-x11 \
    sudo \
    wget \
    xorgxrdp \
    xrdp \
    openssh-server \
    git \
    software-properties-common \
    ca-certificates \
    gnupg2 \
    apt-transport-https

# 3. Remove unneeded packages
RUN apt remove -y light-locker xscreensaver || true && \
    apt autoremove -y

# 4. Install Visual Studio Code
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg && \
    install -D -o root -g root -m 644 microsoft.gpg /etc/apt/keyrings/microsoft.gpg && \
    sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list' && \
    rm microsoft.gpg && \
    apt-get update && \
    apt-get install -y code && \
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt -y install ./google-chrome-stable_current_amd64.deb

# 5. Install gof5 (F5 VPN client)
RUN wget https://github.com/kayrus/gof5/releases/download/v0.1.4/gof5_linux_amd64 && \
    chmod +x gof5_linux_amd64 && \
    mv gof5_linux_amd64 /usr/local/bin/gof5

# 6. (Optional) Set capabilities for gof5
RUN apt-get update && apt-get install -y libcap2-bin && rm -rf /var/lib/apt/lists/*
RUN setcap 'cap_net_admin,cap_net_bind_service+ep' /usr/local/bin/gof5

# 7. Clean up apt caches
RUN rm -rf /var/cache/apt /var/lib/apt/lists/*

# 8. Configure SSH
RUN mkdir -p /var/run/sshd && \
    sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/^#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

# 9. Copy entrypoint script
COPY ubuntu-run.sh /usr/bin/
RUN mv /usr/bin/ubuntu-run.sh /usr/bin/run.sh && \
    chmod +x /usr/bin/run.sh

# 10. Expose XRDP & SSH
EXPOSE 3389 22

# 11. Entry point
ENTRYPOINT ["/usr/bin/run.sh"]

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update && \
    apt-get -y upgrade

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

RUN apt remove -y light-locker xscreensaver || true && \
    apt autoremove -y

RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg && \
    install -D -o root -g root -m 644 microsoft.gpg /etc/apt/keyrings/microsoft.gpg && \
    sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list' && \
    rm microsoft.gpg && \
    apt-get update && \
    apt-get install -y code

RUN rm -rf /var/cache/apt /var/lib/apt/lists/*

RUN mkdir -p /var/run/sshd && \
    sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/^#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

COPY ubuntu-run.sh /usr/bin/
RUN mv /usr/bin/ubuntu-run.sh /usr/bin/run.sh && \
    chmod +x /usr/bin/run.sh

EXPOSE 3389 22

ENTRYPOINT ["/usr/bin/run.sh"]

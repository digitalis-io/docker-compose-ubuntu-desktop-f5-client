#!/bin/bash

RDP_GID=${RDP_GID:-9999}
RDP_UID=${RDP_UID:-9999}
RDP_USER=${RDP_USER:-admin}
RDP_PASSWORD=${RDP_USER:-admin}

start_xrdp_services() {
    # Preventing xrdp startup failure
    rm -rf /var/run/xrdp-sesman.pid
    rm -rf /var/run/xrdp.pid
    rm -rf /var/run/xrdp/xrdp-sesman.pid
    rm -rf /var/run/xrdp/xrdp.pid

    # Use exec ... to forward SIGNAL to child processes
    xrdp-sesman && exec xrdp -n
}

start_ssh_services() {
    service ssh restart
    wait
}


stop_xrdp_services() {
    xrdp --kill
    xrdp-sesman --kill
    exit 0
}


echo Entryponit script is Running...
echo

addgroup --gid 9999 $RDP_USER
echo "username is $RDP_USER"
useradd -m -u 9999 -s /bin/bash -g $RDP_USER $RDP_USER
wait
#getent passwd | grep foo
echo ${RDP_USER}:${RDP_PASSWORD} | chpasswd 
wait
usermod -aG sudo $RDP_USER


echo -e "This script is ended\n"

echo -e "starting sshd services...\n"
start_ssh_services

echo -e "starting xrdp services...\n"

trap "stop_xrdp_services" SIGKILL SIGTERM SIGHUP SIGINT EXIT
start_xrdp_services

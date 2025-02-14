#!/bin/bash


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

addgroup admin
echo "username is admin"
useradd -m -s /bin/bash -g admin admin
wait
#getent passwd | grep foo
echo admin:admin | chpasswd 
wait
usermod -aG sudo admin


echo -e "This script is ended\n"

echo -e "starting sshd services...\n"
start_ssh_services

echo -e "starting xrdp services...\n"

trap "stop_xrdp_services" SIGKILL SIGTERM SIGHUP SIGINT EXIT
start_xrdp_services
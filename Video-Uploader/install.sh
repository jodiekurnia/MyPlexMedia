#!/bin/bash
apt-get update && apt-get upgrade -y
apt update && apt upgrade -y

#install Bazarr
apt-get install git-core python3-pip -y && git clone https://github.com/morpheus65535/bazarr.git /opt/Bazarr
cd /opt/Bazarr && pip3 install -r requirements.txt

#install Rclone
curl https://rclone.org/install.sh | sudo bash

#install Mono
apt install gnupg ca-certificates
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list
apt update && apt install mono-devel mono-complete -y

#install Sonarr
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0xA236C58F409091A18ACA53CBEBFF6B99D9B78493
echo "deb http://apt.sonarr.tv/ master main" | sudo tee /etc/apt/sources.list.d/sonarr.list
apt update && apt install nzbdrone -y

#install radarr
apt update && apt install curl mediainfo
cd /root/ && apt update && apt install -y curl mediainfo && curl -L -O $( curl -s https://api.github.com/repos/Radarr/Radarr/releases | grep linux.tar.gz | grep browser_download_url | head -1 | cut -d \" -f 4 ) && tar -xvzf Radarr.develop.*.linux.tar.gz && mv Radarr /opt

#install mergefs
cd /root/ && wget https://github.com/trapexit/mergerfs/releases/download/2.29.0/mergerfs_2.29.0.ubuntu-bionic_amd64.deb && dpkg -i mergerfs*.deb

#install deluge + deluge-web
add-apt-repository ppa:deluge-team/ppa
apt install deluged deluge-webui
adduser --system --group deluge
gpasswd -a root deluge

#create needed directory
mkdir /local/ && mkdir /local/TV\ Shows && mkdir /local/Movies
mkdir /GD
mkdir /gmedia

#copy systemd file
cp systemd/deluged.service /lib/systemd/system/deluged.service
cp systemd/deluge-web.service /lib/systemd/system/deluge-web.service
cp systemd/gmedia.service /lib/systemd/system/gmedia.service
cp systemd/sonarr.service /lib/systemd/system/sonarr.service
cp systemd/radarr.service /lib/systemd/system/radarr.service
cp systemd/rclone.service /lib/systemd/system/rclone.service

#enable all to start-up
systemctl daemon-reload
systemctl enable deluged.service
systemctl enable deluge-web.service
systemctl enable gmedia.service
systemctl enable sonarr.service
systemctl enable radarr.service
systemctl enable rclone.service

#reboot
reboot
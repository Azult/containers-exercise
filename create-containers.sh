#!/bin/bash

apt-get install build-essential -y

# Docker install
# echo "[*] Install Docker"
# apt install apt-transport-https ca-certificates curl software-properties-common -y
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
# apt update
# apt-cache policy docker-ce
# apt install docker-ce -y
# service docker start


if [ -d "/rootfs" ] 
then
	echo "[-] /rootfs already exist"
else
    cp -rf ./rootfs /rootfs
	mkdir /rootfs/boot
	mkdir /rootfs/home
	mkdir /rootfs/media
	mkdir /rootfs/mnt
	mkdir /rootfs/opt
	mkdir /rootfs/proc
	mkdir /rootfs/srv
	mkdir /rootfs/sys
	mkdir /rootfs/tmp
fi

if [ -d "/etc/legal" ] 
then
	rm /etc/legal
	chmod -x /etc/update-motd.d/*
fi



for i in $(ls -d ./Containers/*/)
do
	chmod +x $i"create.sh"
	$i"./create.sh"
done

#!/bin/bash

user="netns"
fileName="net_ns" #Without .c
password="Aa123456"

echo "[*] Creating '$user' container"

if [ -d "/rootfs/home/$user" ] 
then
	echo "[-] '$user' container already exist"
else
	# Create container home directory
	mkdir /rootfs/home/$user
	# Create user with shell and directory
	useradd -s /rootfs/home/$user/$fileName -d /rootfs/home/$user $user
	# Set password
	echo -e $password'\n'$password'\n' | passwd $user
	# Compile the shell
	cp .$(echo $0|cut -d '.' -f2)$fileName.c /rootfs/home/$user/$fileName.c
	sed -i "1i#define USERID $(id -u $user)" /rootfs/home/$user/$fileName.c
	gcc -w /rootfs/home/$user/$fileName.c -o /rootfs/home/$user/$fileName && chmod u+s /rootfs/home/$user/$fileName

	#Update the rootfs passwd
	tail -n 1 /etc/passwd $1 | while read x; do echo "${x///rootfs/}"; done >> /rootfs/etc/passwd
fi

echo "[*] Installing Redis"
apt install redis-server -y
sudo systemctl enable redis-server.service
echo "maxmemory 256mb" >> /etc/redis/redis.conf
echo "maxmemory-policy allkeys-lru" >> /etc/redis/redis.conf
systemctl restart redis-server.service
apt install php-redis -y
echo 'SET flag "flag{n3v3r f0rg37 7h3 n3t!}"' | nc localhost 6379 | exit
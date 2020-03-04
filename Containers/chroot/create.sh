#!/bin/bash

user="chroot"
fileName="chroot" #Without .c
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
	# Make user sudoer
	usermod -aG sudo $user
	# Set password
	echo -e $password'\n'$password'\n' | passwd $user
	# Compile the shell
	cp .$(echo $0|cut -d '.' -f2)$fileName.c /rootfs/home/$user/$fileName.c
	sed -i "1i#define USERID $(id -u $user)" /rootfs/home/$user/$fileName.c
	gcc -w /rootfs/home/$user/$fileName.c -o /rootfs/home/$user/$fileName && chmod u+s /rootfs/home/$user/$fileName

	#Update the rootfs passwd
	tail -n 1 /etc/passwd $1 | while read x; do echo "${x///rootfs/}"; done >> /rootfs/etc/passwd
fi


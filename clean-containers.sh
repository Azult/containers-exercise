#!/bin/bash

# Removing /rootfs

for i in $(ls -d ./Containers/*/)
do
	chmod +x $i"clean.sh"
	$i"./clean.sh"
done

rm -rf /rootfs
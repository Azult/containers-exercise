#!/bin/bash

user="pidns"

echo "[*] Removing '$user' container"

# Deleting user 
deluser $user --remove-home

echo $user was removed!
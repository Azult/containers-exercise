#!/bin/bash

user="unclosed"

echo "[*] Removing '$user' container"

# Deleting user 
deluser $user --remove-home

echo $user was removed!
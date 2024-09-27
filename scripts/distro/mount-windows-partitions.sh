#!/bin/bash

declare MOUNT_DIR="/mnt"
declare MOUNTED_DIRS="$(ls $MOUNT_DIR | grep -v wsl | grep -v wslg)"

for mountedDir in $MOUNTED_DIRS; do
    sudo mkdir -p "/$mountedDir"
    sudo mount --bind "$MOUNT_DIR/$mountedDir" "/$mountedDir"
done
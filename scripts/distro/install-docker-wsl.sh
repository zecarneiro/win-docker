#!/bin/bash
declare MOUNT_WINDOWS_PARTITIONS_SCRIPT_ORIG="$1"
declare LIB_UTIL="$2"
declare MOUNT_WINDOWS_PARTITIONS_SCRIPT="mount-windows-partitions.sh"

# IMPORT LIB FROM WINDOWS
chmod +x "$LIB_UTIL"
source "$LIB_UTIL"

function installDocker {
    evaladvanced "sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common lsb-release -y"
    evaladvanced "curl -fsSL https://get.docker.com -o get-docker.sh"
    evaladvanced "chmod +x get-docker.sh"
    evaladvanced "sudo ./get-docker.sh"
    evaladvanced "sudo apt-get install docker-ce docker-ce-cli containerd.io -y"
    evaladvanced "rm -rf ./get-docker.sh"
    evaladvanced "sudo systemctl enable docker.service"
    evaladvanced "sudo systemctl enable containerd.service"
}

function configDocker {
    infolog "Add $USER to Docker group"
    evaladvanced "sudo usermod -aG docker \"$USER\""
    evaladvanced "sudo gpasswd -a \"$USER\" docker"

    infolog "Config Docker daemon"
    evaladvanced "sudo cp /lib/systemd/system/docker.service /etc/systemd/system/"
    evaladvanced "sudo sed -i 's/\ -H\ fd:\/\//\ -H\ fd:\/\/\ -H\ tcp:\/\/0.0.0.0:2375/g' /etc/systemd/system/docker.service"
    evaladvanced "sudo systemctl daemon-reload"
    evaladvanced "sudo systemctl restart docker.service"

    infolog "Create service to mount windows partitions for docker"
    evaladvanced "sudo cp \"$MOUNT_WINDOWS_PARTITIONS_SCRIPT_ORIG\" /$MOUNT_WINDOWS_PARTITIONS_SCRIPT"
    evaladvanced "sudo chmod +x /$MOUNT_WINDOWS_PARTITIONS_SCRIPT"
    createservice "mount-windows-partitions-docker" "/$MOUNT_WINDOWS_PARTITIONS_SCRIPT" "Mount windows partitions docker"
}

function main {
    installDocker
    configDocker    
}
main

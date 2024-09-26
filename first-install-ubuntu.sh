#!/bin/bash

function addServiceToKeepAlive {
    local serviceFile="keep-distro-alive.service"
    echo "[Unit]
Description=Keep Distro Alive

[Service]
ExecStart=/mnt/c/Windows/System32/waitfor.exe MakeDistroAlive

[Install]
WantedBy=multi-user.target" >> /etc/systemd/system/$serviceFile
    sudo systemctl start $serviceFile
    sudo systemctl enable $serviceFile
}

function addWslFileConfParam {
    local tag="$1"
    local param="$2"
    local value="$3"
    if [[ $(cat $wslConfFile | grep -Ec "\[${tag}\]") -le 0 ]]; then
        echo "[${tag}]" | sudo tee -a $wslConfFile > /dev/null
    fi
    if [[ $(cat $wslConfFile | grep -Ec "${param}=") -gt 0 ]]; then
        sed -i "s/${param}=.*/${param}=${value}/g" $wslConfFile
    else
        sed -i "/\[${tag}\]/a ${param}=${value}" $wslConfFile
    fi
}

function configWslFile {
    local wslConfFile="/etc/wsl.conf"
    cat /etc/wsl.conf

    # Config boot tag with systemd
    addWslFileConfParam "boot" "systemd" "true"

    # Config wsl2 tag wit memory
    addWslFileConfParam "wsl2" "memory" "4GB"

    # Config wsl2 tag wit processors
    addWslFileConfParam "wsl2" "processors" "2"
}

function main () {
    set -euxo pipefail
    # Upgrade
    sudo apt update
    sudo apt upgrade -y
    configWslFile
    addServiceToKeepAlive
    set +x
}
main

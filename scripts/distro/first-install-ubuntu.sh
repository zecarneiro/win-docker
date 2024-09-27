#!/bin/bash
declare RAM="$1"
declare PROCESSOR="$2"
declare LIB_UTIL="$3"

# IMPORT LIB FROM WINDOWS
chmod +x "$LIB_UTIL"
source "$LIB_UTIL"

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

    # Config boot tag with systemd
    addWslFileConfParam "boot" "systemd" "true"

    # Config wsl2 tag with memory
    if [[ "${RAM}" != "ALL" ]]; then
        addWslFileConfParam "wsl2" "memory" "$RAM"
    fi
    # Config wsl2 tag with processor
    if [[ "${PROCESSOR}" != "ALL" ]]; then
        addWslFileConfParam "wsl2" "processors" "$PROCESSOR"
    fi
}

function main {
    evaladvanced "sudo apt update"
    configWslFile
    createservice "keep-distro-alive" "/mnt/c/Windows/System32/waitfor.exe MakeDistroAlive" "Keep Distro Alive"
}
main



#!/bin/bash

function evaladvanced () {
    local expression="$1"
    echo ">>> $expression"
    eval "$expression"
}

evaladvanced "sudo usermod -aG docker \"$USER\""
evaladvanced "sudo gpasswd -a \"$USER\" docker"
evaladvanced "sudo cp /lib/systemd/system/docker.service /etc/systemd/system/"
evaladvanced "sudo sed -i 's/\ -H\ fd:\/\//\ -H\ fd:\/\/\ -H\ tcp:\/\/127.0.0.1:2375/g' /etc/systemd/system/docker.service"
evaladvanced "sudo systemctl daemon-reload"
evaladvanced "sudo systemctl restart docker.service"
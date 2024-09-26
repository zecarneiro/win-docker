#!/bin/bash
declare DOCKER_COMPOSE_INSTALL_FILE="/usr/local/bin/docker-compose"
declare DOCKER_COMPOSE_VERSION="2.24.6"

function evaladvanced () {
    local expression="$1"
    echo ">>> $expression"
    eval "$expression"
}

install_dependecies() {
    evaladvanced "sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common lsb-release -y"
}

install_dependecies
evaladvanced "curl -fsSL https://get.docker.com -o get-docker.sh"
evaladvanced "chmod +x get-docker.sh"
evaladvanced "sudo ./get-docker.sh"
evaladvanced "sudo apt-get install docker-ce docker-ce-cli containerd.io -y"

read -p "Do you want to install the latest version of the Docker Compose(Default: $DOCKER_COMPOSE_VERSION)? [y/N]" response
if [ "$response" == "y" ]||[ "$response" == "Y" ]; then
    DOCKER_COMPOSE_VERSION=$(curl --silent https://api.github.com/repos/docker/compose/releases/latest | grep -Po '"tag_name": "\K.*\d')
fi
evaladvanced "sudo curl -L \"https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)\" -o $DOCKER_COMPOSE_INSTALL_FILE"
evaladvanced "sudo chmod +x \"$DOCKER_COMPOSE_INSTALL_FILE\""
evaladvanced "sudo systemctl enable docker.service"
evaladvanced "sudo systemctl enable containerd.service"
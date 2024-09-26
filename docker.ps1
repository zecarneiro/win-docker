$NAME="Docker"
$DESCRIPTION="If have error with Rancher Desktop, run as admin: 1- wsl --update /2- wsl --shutdown /3- netsh winsock reset."
$IS_DISABLED=$false
$DOCKER_BIN_DIR = "$MS_PLATFORM_BIN_DIR\docker"

function config_docker {
    $dockerGrantUserScript = "$DOCKER_BIN_DIR\config-docker-startup.ps1"
    $dockerGrantUserScriptInstall = "$OTHER_APPS_DIR\config-docker-startup.ps1"
    addalias -name "dockerclean" -command "docker system prune -a; docker system prune -a --volumes"

    infolog "Set Docker compose to convert windows paths"
    setenv "COMPOSE_CONVERT_WINDOWS_PATHS" "1" "User"

    infolog "Create docker service"
    evaladvanced "sudo dockerd --register-service --service-name `"docker`""
    evaladvanced "sudo Start-Service docker"

    infolog "Create Grant User Access for docker with task at logon"
    evaladvanced "Copy-Item -Path `"$dockerGrantUserScript`" -Destination `"$dockerGrantUserScriptInstall`" -Force"
    evaladvanced "sudoshell createtask -name `"DockerGrantUser`" -executable `"$dockerGrantUserScriptInstall`" -isPowershellScript"
}

function install_docker {
    evaladvanced "scoop bucket add main"
    evaladvanced "scoop install main/docker"
    $dockerComposeVersion = "2.24.6"
    if ((confirm "Do you want to install the latest version of the Docker Compose(Default: $dockerComposeVersion)")) {
        $dockerComposeVersion = ""
    } else {
        $dockerComposeVersion = "@${dockerComposeVersion}"
    }
    evaladvanced "sudo scoop install main/docker-compose${dockerComposeVersion}"
    if ((confirm "Enable Windows Features(Hyper-V and Containers)")) {
        evaladvanced "sudo Enable-WindowsOptionalFeature -Online -FeatureName containers -All"
        evaladvanced "sudo Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All"
    }
}

function install_docker_wsl {
    infolog "Installing docker on WSL"
    runBashScriptWSL "$DOCKER_BIN_DIR\install-docker-wsl.sh" $true
    infolog "Config docker on WSL"
    runBashScriptWSL "$DOCKER_BIN_DIR\config-docker-wsl.sh" $true
    evaladvanced "docker context create linux --docker host=tcp://127.0.0.1:2375"
    wslshutdown
}

function install_portainer {
    evaladvanced "npm install --global portainer-manager-cli"
    create_shortcut_file -name "Portainer Manager" -target portainer-manager-cli -terminal $true
    create_shortcut_file -name Portainer -target powershell -targetArgs "Start-Process 'https://localhost:9443'"
}

function install_dependecies {
    install_node_typescript_javascript
}

function process_ms {
    install_dependecies
    install_docker
    install_docker_wsl
    install_portainer
    config_docker
    warnlog "Please, restart PC before use docker"
}

$NAME="Docker"
function install_docker_from_scoop {
    headerlog "Install $NAME from scoop package manager"
    waituntil 5
    evaladvanced "scoop bucket add main"
    evaladvanced "scoop install main/docker"
    evaladvanced "scoop install main/docker-buildx"
    if ($global:DOCKER_COMPOSE_VERSION -eq "latest") {
        evaladvanced "scoop install main/docker-compose"
    } else {
        evaladvanced "scoop install main/docker-compose@$global:DOCKER_COMPOSE_VERSION"
    }
}

function install_docker_wsl {
    headerlog "Installing docker on WSL $DISTRO_NAME"
    waituntil 5
    $mountWindowsPartitionsScript = (wintowslpath "$SCRIPT_DISTRO_DIR\mount-windows-partitions.sh")
    runBashScriptWSL -scriptOrigPath "$SCRIPT_DISTRO_DIR\install-docker-wsl.sh" -withSudo $false -distro "$DISTRO_NAME" -arguments @("$mountWindowsPartitionsScript", "$(wintowslpath "$VENDOR_DIR\bash-utils\main-utils.sh")")
    setenv "COMPOSE_CONVERT_WINDOWS_PATHS" "1" "User"
    setenv "DOCKER_HOST" "tcp://localhost:2375" "User"
    wslshutdown
}

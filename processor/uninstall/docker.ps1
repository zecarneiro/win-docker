$NAME="Docker"

function uninstall_docker_from_scoop {
    titlelog "Uninstall $NAME from scoop package manager"
    evaladvanced "scoopuninstall docker"
    evaladvanced "scoopuninstall docker-compose"
    evaladvanced "scoopuninstall docker-buildx"
    scoopclean

}

function process_docker {
    uninstall_docker_from_scoop
    deleteenv "DOCKER_HOST" "User"
    deleteenv "COMPOSE_CONVERT_WINDOWS_PATHS" "User"
    deletedirectory "$home\.docker"
}

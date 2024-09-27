function process_wsl {
    titlelog "Uninstall WSL $DISTRO_NAME Distro"
    wsluninstall $DISTRO_NAME
    wslshutdown
    del_boot_application "WslUbuntu2404"
}

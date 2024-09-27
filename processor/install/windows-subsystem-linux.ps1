function install_distro {
    headerlog "Install WSL: $DISTRO_NAME"
    waituntil 5
    infolog "To see all distro available, run: wsl --list --online"
    infolog "After installing $DISTRO_NAME, run command(exit from WSL): exit"
    pause
    evaladvanced "wsl --install -d $DISTRO_NAME"
    runbashscriptWSL -scriptOrigPath "$SCRIPT_DISTRO_DIR\first-install-ubuntu.sh" -withSudo $true -distro "$DISTRO_NAME" -arguments @("$global:DISTRO_MAX_MEMORY_AVAILABLE", "$global:DISTRO_MAX_PROCESSOR_AVAILABLE", "$(wintowslpath "$VENDOR_DIR\bash-utils\main-utils.sh")")
    wslshutdown
    addalias "restart-ubuntu-2404" -command "wslshutdown; wsl.exe -d $DISTRO_NAME -- echo `"Running WSL $DISTRO_NAME`""
}
function set_autostart {
    headerlog "Set WSL $DISTRO_NAME to start on boot"
    waituntil 5
    add_boot_application -name "WslUbuntu2404" -command "$(which wsl.exe)" -commandArgs "-d $DISTRO_NAME -- echo `"Running WSL`"" -hidden
}

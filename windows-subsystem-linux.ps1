$NAME="Windows Subsystem for Linux"
$DESCRIPTION=""
$IS_DISABLED=$false

function win10 {
    titlelog "For Windows 10"
    log "1. Enable Virtual Machine Platform feature"
    log "`t- dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart"
    log "2. Enable WSL feature"
    log "`t- dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart"
    log "3. Restart Win 10 Machine"
    log "4. To set the WSL default version to 2. Any distribution installed after this, would run on WSL 2"
    log "`t- wsl --set-default-version 2"
    pause
}

function win11 {
    titlelog "For Windows 11"
    log "1. Start CMD with administrative privileges."
    log "2. Execute command: wsl --install"
    log "3. Restart Win 11 Machine"
    pause
}


function process_ms {
    win10
    log
    log
    win11
    log
    infolog "To see all distro available, run: wsl --list --online"
    if ((confirm "Do you want to install Ubuntu 24.04 LTS on WSL")) {
        infolog "After installing, run command: exit"
        evaladvanced "wsl --install -d Ubuntu-24.04"
        runBashScriptWSL "$MS_PLATFORM_BIN_DIR\wsl\first-install-ubuntu.sh" $true
        wslshutdown
        add_boot_application "wsl-boot" "wsl" "-- echo `"Running WSL`"" -hidden
    }
}


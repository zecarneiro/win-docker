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

function process_wsl_enable {
    headerlog "How to enable WSL on Windows"
    if ((confirm "See how for Windows 10")) {
        win10
        log
    }
    if ((confirm "See how for Windows 11")) {
        win11
        log
    }
}

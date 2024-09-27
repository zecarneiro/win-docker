param(
    [switch] $release,
    [switch] $clean
)
$VERSION = "1.0.0"
$ROOT_DIR = "$PSScriptRoot"
$VENDOR_DIR = "$ROOT_DIR\vendor"
$SCRIPT_DIR = "$ROOT_DIR\scripts"
$SCRIPT_DISTRO_DIR = "$SCRIPT_DIR\distro"
$DISTRO_NAME="Ubuntu-24.04"
$global:DISTRO_MAX_MEMORY_AVAILABLE=$null
$global:DISTRO_MAX_PROCESSOR_AVAILABLE=$null
$global:DOCKER_COMPOSE_VERSION=$null
$RELEASE_APP = "windocker-$VERSION"
$RELEASE_DIR = "$ROOT_DIR\$RELEASE_APP"
$RELEASE_PACKAGE_FILE = "$ROOT_DIR\${RELEASE_APP}.zip"

# ---------------------------------------------------------------------------- #
#                          IMPORT POWERSHELL UTILS LIB                         #
# ---------------------------------------------------------------------------- #
. "$VENDOR_DIR\powershell-utils\MainUtils.ps1"

function generateReleasePackage() {
    titlelog "Generating release package"
    deletedirectory "$RELEASE_DIR"
    deletefile "$RELEASE_PACKAGE_FILE"
    mkdir "$RELEASE_DIR" | Out-Null
    $excludes = "$RELEASE_APP", ".git", ".gitignore", ".gitmodules"
    Get-ChildItem "$ROOT_DIR" | Where-Object{$_.Name -notin $excludes} | Copy-Item -Destination "$RELEASE_DIR" -Recurse -Force
    Compress-Archive -Path "$RELEASE_DIR" -DestinationPath "$RELEASE_PACKAGE_FILE"
    deletedirectory "$RELEASE_DIR"
}

function cleanApp {
    titlelog "Cleaning..."
    deletedirectory "$RELEASE_DIR"
    deletefile "$RELEASE_PACKAGE_FILE"
}

function loadConfiguration {
    titlelog "Loading configuration"
    $configurationJson = (Get-Content "$ROOT_DIR\config.json" | ConvertFrom-Json)
    $global:DISTRO_MAX_MEMORY_AVAILABLE = $configurationJson.distroMaxMemoryAvailable
    $global:DISTRO_MAX_PROCESSOR_AVAILABLE = $configurationJson.distroMaxProcessorAvailable
    if ([string]::IsNullOrEmpty($global:DISTRO_MAX_MEMORY_AVAILABLE)) {
        $global:DISTRO_MAX_MEMORY_AVAILABLE = "ALL"
    }
    if ([string]::IsNullOrEmpty($global:DISTRO_MAX_PROCESSOR_AVAILABLE)) {
        $global:DISTRO_MAX_PROCESSOR_AVAILABLE = "ALL"
    }
    
    $global:DOCKER_COMPOSE_VERSION = $configurationJson.dockerComposeVersion
    if ([string]::IsNullOrEmpty($global:DOCKER_COMPOSE_VERSION)) {
        $global:DOCKER_COMPOSE_VERSION = "latest"
    }

    # Print the configuration
    log "Distro - name: $DISTRO_NAME (Unchanged, because was tested)" 
    log "Distro - Limits VM memory to use, this can be set as whole numbers using GB or MB: $global:DISTRO_MAX_MEMORY_AVAILABLE"
    log "Distro - Sets the VM to use virtual processors: $global:DISTRO_MAX_PROCESSOR_AVAILABLE"
    log "Docker - compose version: $global:DOCKER_COMPOSE_VERSION"
    if (!(confirm "Is Configuration loaded correctly" -isYesDefault $true)) {
        exit 0
    }
    log ""
}

function printMenu {
    titlelog "Install Docker on Windows(Requires WSL, Scoop)"
    log "1. How to enable WSL on Windows 10/11"
    log "---"
    log "2. Install Ubuntu 24.04(WSL)"
    log "3. Set WSL distro to auto start on boot"
    log "4. Install Docker(Requires Scoop)"
    log "5. Install Docker(Requires WSL: $DISTRO_NAME)"
    log "6. All"
    log "PRESS ENTER to Exit"
    return (read_user_keyboard "Insert an option")
}

function main {
    loadConfiguration
    while ($true) {
        $option = printMenu
        if ($option -eq 1) {
            evaladvanced ". '$ROOT_DIR\processor\install\wsl-how-to-enable.ps1'; process_wsl_enable"
        }
        if($option -eq 2 -or $option -eq 6) {
            evaladvanced ". '$ROOT_DIR\processor\install\windows-subsystem-linux.ps1'; install_distro"
            infolog "You can now restart your distro with powershell command: restart-ubuntu-2404"
        }
        if($option -eq 3 -or $option -eq 6) {
            evaladvanced ". '$ROOT_DIR\processor\install\windows-subsystem-linux.ps1'; set_autostart"
        }
        if ($option -eq 4 -or $option -eq 6) {
            evaladvanced ". '$ROOT_DIR\processor\install\docker.ps1'; install_docker_from_scoop"
        }
        if ($option -eq 5 -or $option -eq 6) {
            evaladvanced ". '$ROOT_DIR\processor\install\docker.ps1'; install_docker_wsl"
        }
        if ([string]::IsNullOrEmpty($option)) {
            exit 0
        }
    }
}
if ($release) {
    generateReleasePackage
} elseif ($clean) {
    cleanApp
} else {
    if (!(isadmin)) {
        errorlog "The script cannot be run because it contains a statement for running as Administrator"
        exit 1
    }
    main
}


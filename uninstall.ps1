#Requires -RunAsAdministrator
$ROOT_DIR = "$PSScriptRoot"
$VENDOR_DIR = "$ROOT_DIR\vendor"
$DISTRO_NAME="Ubuntu-24.04"

# ---------------------------------------------------------------------------- #
#                          IMPORT POWERSHELL UTILS LIB                         #
# ---------------------------------------------------------------------------- #
. "$VENDOR_DIR\powershell-utils\MainUtils.ps1"

evaladvanced ". '$ROOT_DIR\processor\uninstall\docker.ps1'; process_docker"
evaladvanced ". '$ROOT_DIR\processor\uninstall\windows-subsystem-linux.ps1'; process_wsl"
del_boot_application "WslUbuntu2404"
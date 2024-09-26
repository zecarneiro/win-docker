function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false)  {
    Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -file "{0}" -shouldAssumeToBeElevated -workingDirOverride "{1}"' -f ($myinvocation.MyCommand.Definition, "$workingDirOverride"))
}

function grantUserAccess {
    $account="${env:USERNAME}" 
    $npipe = "\\.\pipe\docker_engine"
    $dInfo = New-Object "System.IO.DirectoryInfo" -ArgumentList $npipe
    $dSec = $dInfo.GetAccessControl()
    $fullControl =[System.Security.AccessControl.FileSystemRights]::FullControl
    $allow =[System.Security.AccessControl.AccessControlType]::Allow
    $rule = New-Object "System.Security.AccessControl.FileSystemAccessRule" -ArgumentList $account,$fullControl,$allow
    $dSec.AddAccessRule($rule)
    $dInfo.SetAccessControl($dSec)
}

function main {
    docker context use linux
    grantUserAccess
}
main

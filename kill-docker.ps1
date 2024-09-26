# Leave swarm mode (this will automatically stop and remove services and overlay networks)
docker swarm leave --force
# Stop all running containers
docker ps --quiet | ForEach-Object {docker stop $_}
#just to be sure, sleep 5 seconds
Start-Sleep -s 5
#take ownership of docker files
if (Test-Path "C:\ProgramData\Docker") { takeown.exe /F "C:\ProgramData\Docker" /R /A /D Y }
if (Test-Path "C:\ProgramData\Docker") { icacls "C:\ProgramData\Docker\" /T /C /grant Administrators:F }
#invoke cmd to delete docker files
cmd /c rmdir /s /q "C:\ProgramData\Docker"
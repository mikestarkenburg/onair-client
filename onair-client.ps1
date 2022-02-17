# Stark's Onair Windows Powershell Client Script
#
# todo:  only ping on change of state, tray icon, start on boot, logging


$global:ErrorActionPreference= 'SilentlyContinue'
$global:ProgressPreference = 'SilentlyContinue' 
$url = "onair.starkenburg.com"
$user = "Mike"
$seconds = 2


Do {
   if (Get-Process Zoom) 
   {
      # Zoom is active and there are ZERO UDP packets
      If ((Get-NetUDPEndpoint -OwningProcess (Get-Process Zoom).Id -EA 0|Measure-Object).count -lt 1) 
      {
         Write-Host "zoom is open but no meeting"
         Invoke-WebRequest -UseBasicParsing -Uri $url/?LED=OFF | Out-Null
      }

      # Zoom is active and there are UDP packets
      If ((Get-NetUDPEndpoint -OwningProcess (Get-Process Zoom).Id -EA 0|Measure-Object).count -gt 0) 
      {
         Write-Host $user + " is in a meeting"
         Invoke-WebRequest -UseBasicParsing -Uri $url/?LED=BLUE | Out-Null
      }
   } 
   else 
   {
      Write-host "there is no zoom process"
      Invoke-WebRequest -UseBasicParsing -Uri $url/?LED=OFF | Out-Null
   }

   Start-Sleep $seconds
   
}
while ($true)

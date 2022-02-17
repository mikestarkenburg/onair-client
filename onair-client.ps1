# Stark's Onair Windows Powershell Client Script
#
# todo:  tray icon, start on boot, logging


$global:ErrorActionPreference= 'SilentlyContinue'
$global:ProgressPreference = 'SilentlyContinue' 
$url = "onair.starkenburg.com"
$user = "Mike"
$seconds = 2
$laststate = "openIdle"

Do 
{
   If (Get-Process Zoom) 
   {
      # Zoom is active and there are ZERO UDP packets
      If ((Get-NetUDPEndpoint -OwningProcess (Get-Process Zoom).Id -EA 0|Measure-Object).count -lt 1) 
      {
         Write-Host "zoom is open but no meeting"
         If ($laststate -ne "openIdle")
         {
            Invoke-WebRequest -UseBasicParsing -Uri $url/?LED=OFF | Out-Null
            Write-Host "Setting LED OFF"
            $laststate = "openIdle"
         }
      }
      # Zoom is active and there are UDP packets
      If ((Get-NetUDPEndpoint -OwningProcess (Get-Process Zoom).Id -EA 0|Measure-Object).count -gt 0) 
      {
         Write-Host $user "is in a meeting"
         If ($laststate -ne "inMeeting")
         {
            Invoke-WebRequest -UseBasicParsing -Uri $url/?LED=BLUE | Out-Null
            Write-Host "Setting LED BLUE"
            $laststate = "inMeeting"
         }
      }
   } 
   else 
   {
      Write-host "there is no zoom process"
      If ($laststate -ne "noProcess")
      {
         Invoke-WebRequest -UseBasicParsing -Uri $url/?LED=OFF | Out-Null
         Write-Host "Setting LED OFF"
         $laststate = "noProcess"
      }
   }
   Start-Sleep $seconds  
}
while ($true)

# Stark's Onair Windows Powershell Client Script
#
# todo:  light webhooks, logging

$ErrorActionPreference= 'silentlycontinue'
if (Get-Process Zoom) 
{
   # Zoom is active and there are ZERO UDP packets
   If ((Get-NetUDPEndpoint -OwningProcess (Get-Process Zoom).Id -EA 0|Measure-Object).count -lt 1) {Write-Host "zoom is open but no meeting"}

   # Zoom is active and there are UDP packets
   If ((Get-NetUDPEndpoint -OwningProcess (Get-Process Zoom).Id -EA 0|Measure-Object).count -gt 0) {Write-Host "Mike is in a meeting"}
}
else {Write-host "there is no zoom process"}

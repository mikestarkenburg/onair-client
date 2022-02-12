# Stark's Onair Windows Powershell Client Script
#
# todo:  variable webhooks, logging

$global:ErrorActionPreference= 'SilentlyContinue'
$global:ProgressPreference = 'SilentlyContinue' 
if (Get-Process Zoom) 
{
   # Zoom is active and there are ZERO UDP packets
   If ((Get-NetUDPEndpoint -OwningProcess (Get-Process Zoom).Id -EA 0|Measure-Object).count -lt 1) 
   {
      Write-Host "zoom is open but no meeting"
      Invoke-WebRequest -UseBasicParsing -Uri 192.168.5.110/?LED=OFF | Out-Null
   }

   # Zoom is active and there are UDP packets
   If ((Get-NetUDPEndpoint -OwningProcess (Get-Process Zoom).Id -EA 0|Measure-Object).count -gt 0) 
   {
      Write-Host "Mike is in a meeting"
      Invoke-WebRequest -UseBasicParsing -Uri 192.168.5.110/?LED=BLUE | Out-Null
   }
}
else 
{
   Write-host "there is no zoom process"
   Invoke-WebRequest -UseBasicParsing -Uri 192.168.5.110/?LED=OFF | Out-Null
}
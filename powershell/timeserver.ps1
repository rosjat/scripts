# Script:  timeserver.ps1
# Author:  Markus Rosjat <markus.rosjat@gmail.com>
# Version: 1.0 
# Date:    2023-10-10 

<#
.SYNOPSIS 
   Simple Script to add a new timserver to the windows registry
.DESCRIPTION

.PARAMETER ComputerName
    A string that represents a FQDN or IP address for an ntp server.
.PARAMETER Default
    A switch to make the new Server the default time server to use.
.NOTES
    THIS SCRIPT NEEED ELEVATED RIGHTS TO WORK!!!
    It's based on my needs so feel free to extend.
.EXAMPLE
	PS > .\timeserver.ps1 -ComputerName pool.ntp.org 
.EXAMPLE
	PS > .\timeserver.ps1 -ComputerName pool.ntp.org -Default
#>
[CmdletBinding()]
Param
    (
        [string]$ComputerName,
		[switch]$Default
    )

$pwd = pwd
Set-Location -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DateTime\Servers
$NextPropertyName = $(get-item .).ValueCount

Set-ItemProperty . -Name $NextPropertyName -Value $ComputerName
if($Default)
{
    Set-ItemProperty . -Name "(default)" -Value $NextPropertyName
}
Set-Location $pwd

# Script:  export_putty_settings.ps1
# Author:  Markus Rosjat <markus.rosjat@gmail.com>
# Version: 1.0 
# Date:    2017-06-23 

<#
.SYNOPSIS 
   Simply writes the regkeys for the PuTTY Tool into a reg file.
.DESCRIPTION
   Simple Script to export PuTTY Tool Settings from the Registry.
   The created file can be used to import the Registry Informations
   to a different machine or after a fresh install.
.PARAMETER RegFile
    path to the reg file to store the exported information in.
.PARAMETER JumpList
    only export the jumplist subkey.
.PARAMETER Sessions
    only export the sessions subkey.
.PARAMETER HostKeys
    only export the hostkeys subkey
.PARAMETER All
    export all subkeys including jumplist, sessions and hostkeys.
.NOTES
    It would be nice to refactor the script to a Cmdlet and do some more
    sanity checking.
.EXAMPLE
    ./export_putty_settings.ps1 -Regfile d:\putty.reg -All
.EXAMPLE
    ./export_putty_settings.ps1 -Regfile -All
.EXAMPLE
    ./export_putty_settings.ps1 -Regfile d:\putty.reg -Sessions
#>
[CmdletBinding(DefaultParameterSetName="All")]
Param
    (
        [Parameter(ValueFromPipeline=$true,
                    ParameterSetName="All")] 
        [Parameter(ValueFromPipeline=$true,
                    ParameterSetName="JumpList")]
        [Parameter(ValueFromPipeline=$true,
                    ParameterSetName="Sessions")]
        [Parameter(ValueFromPipeline=$true,
                    ParameterSetName="HostKeys")]
        [string]$RegFile = [Environment]::GetFolderPath("Desktop") + "\putty.reg", # put in your default

        [Parameter(ParameterSetName="JumpList")]
        [switch]$JumpList,
                
        [Parameter(ParameterSetName="Sessions")] 
        [switch]$Sessions,
        
        [Parameter(ParameterSetName="HostKeys")] 
        [switch]$HostKeys, 

        [Parameter(ParameterSetName="All")] 
        [switch]$All
    )

$BaseKey = "HKCU\Software\SimonTatham\PuTTY"

if ($JumpList.IsPresent)
{
    $BaseKey +="\Jumplist"
}

if ($Sessions.IsPresent)
{
    $BaseKey +="\Sessions"
}

if($HostKeys.IsPresent)
{
    $BaseKey +="\SshHostKeys"
}

reg export $BaseKey ($RegFile)

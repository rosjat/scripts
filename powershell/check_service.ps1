# Script:  check_or_start_service.ps1
# Author:  Markus Rosjat <markus.rosjat@gmail.com>
# Version: 1.0 
# Date:    2016-10-05 
<#
.SYNOPSIS 
   Checks if a service on the windows machine is running.
.DESCRIPTION
   Simple Script to check if a service is running.
   If it's not running we try to start it again and if something
   strange happens we should get a mail to a specified emal account.

.PARAMETER Service
    Name of the service, you might want to use Get-Service to find the right name.
.PARAMETER Status
    Name of the status we want to check. This should be something like 'running'
.PARAMETER Mailserver
    Name of a MS Exchange Mailserver in your AD Domain
.PARAMETER SendTo
    A emailaddress that should be known to your MS Exchange Mailserver
.PARAMETER SentFrom
    A emailaddress that should be known to your MS Exchange Mailserver
.NOTES
   This script is intended to be used in a AD Domain environement with a 
   MS Exchange Server present. We use this to check the POPcon Service. 
   PopCon is used to fetch mail from an external Mailserver and deliver it 
   to the local MS Exchange Server. A scenario for smaller companies with
   an external hoster for there toplevel domain.
.EXAMPLE
    ./check_or_start_service -Service POPcon
#>
Param
    (
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)] 
        [string]$Service = "<ServiceName>", # put in your default

        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)] 
        [string]$Status = "Running", 

        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)] 
        [string]$Mailserver = "<MS Exchange ServerName>", # put in your default

        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)] 
        [string]$SendTo = "<EmailAddress>", # put in your default

        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)] 
        [string]$SentFrom = “<EmailAddress>” # put in your default
    )

try
{
    $result = Get-Service -Name $Service -ErrorAction Stop
    if ($result.Status -ne $Status)
    {
        Start-Service $Service -ErrorAction Stop
    }
}
catch
{
    $ErrorMessage = $_.Exception.Message
    $today = Get-Date -UFormat "%Y%m%d"
    # we sent a mail to our log account
    Send-MailMessage  -SmtpServer $Mailserver `
                      -to $SendTo `
                      -from $SentFrom `
                      -Subject “$Service $env:COMPUTERNAME $today” `
                      -body $ErrorMessage`
                      -Encoding ([System.Text.Encoding]::UTF8)
    Break
}   


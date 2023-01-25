<#PSScriptInfo

.AUTHOR Markus Rosjat <markus.rosjat@gmail.com>

.VERSION 1.0 

.RELEASENOTE 2023-01-25

#> 

<#
.SYNOPSIS 
   Send an email if the windows backup run successfully or with errors.
.DESCRIPTION
   Simple Script to send a mail if a Event in the Eventlog occurs. Since 
   Microsoft doesnt support sending mail on an event anymore we need to do 
   a little extra work to make it work for our needs ...
.PARAMETER Success
    Switch to indicate the script should create a mail with information for a successful backup.
.PARAMETER Failure
    Switch to indicate the script should create a mail with information for a failed backup.
.NOTES
   I dont do a lot of paramter definitions for this script since everyone should be able to 
   set the nessesary stuff once and call it a day.
.EXAMPLE
    ./check_or_start_service -Success
.EXAMPLE
    ./check_or_start_service -Failure
#>
[CmdletBinding(DefaultParameterSetName="Success")]
Param
    (
        [Parameter(Mandatory=$false, 
					ParameterSetName = "Success",
                	ValueFromPipeline=$true,
                	ValueFromPipelineByPropertyName=$true)] 
        [switch]$Success,

		[Parameter(Mandatory=$false, 
					ParameterSetName = "Failure",
					ValueFromPipeline=$true,
					ValueFromPipelineByPropertyName=$true)] 
		[switch]$Failure
    )

#we could define the credentials and password here but we might wanna store them in a file for a little more security ...
$credential_file = "D:\path\to\your\credential\file"
$smtp_user = "mailaddress@domain.tld"
#$credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $smtp_user, (Get-Content $credential_file | ConvertTo-SecureString)
$from = "Backup `<$smtp_user`>"
$to = "mailaddress@domain.tld"
$smtp = "mailserver.domain.tld"
$subject = "Backup - $(Get-Date  -Format dd.MM.yyyy)"

$backup_log_dir = "C:\Windows\Logs\WindowsServerBackup\"

if ($Success)
{
	$body = "Backup ran successfully`n`n" 
	$backup_file_pattern = "Backup-$((Get-Date).ToString("dd-MM-yyyy"))_"
}
if ($Failure) {
	$body = "Backup ran with errors`n`n"
	$backup_file_pattern = "Backup_Error-$((Get-Date).ToString("dd-MM-yyyy"))_"
}

if($Success -or $Failure)
{
	# Get-Item should work for multiple patterns if we use -Include but somethimes it doesnt work for me ...
	$body += (Get-ChildItem -Path $backup_log_dir -Filter $backup_file_pattern| Get-Content -Raw)

	Send-MailMessage  -SmtpServer $smtp -Port 25 -Credential $credentials -to $to  -from $from -Subject $subject -Body $body -Encoding ([System.Text.Encoding]::UTF8) | Out-Null
}


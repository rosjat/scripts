# Script:  backup_restore_db.ps1
# Author:  Markus Rosjat <markus.rosjat@gmail.com>
# Version: 1.1
# Date:    2016-10-06

<#
.SYNOPSIS 
   Script to backup or restore a MSSQLServer database.
.DESCRIPTION
   The script backups or restores a MSSQL database from a MSSQLServer instance to or from a
   database backupfile (<Database>-<YYYYMMHM>.bak). This script will do a full backup and a 
   full restore by default. It also writes to a logfile in the same location. The naming 
   convention of the logfile is '<Database>-<Task>.log'. There is no log rotation involved!
.PARAMETER SQLServer
    The name of the machine with the MSSQLServer installation
.PARAMETER Instance
    Name of the MSSQLServer Instance
.PARAMETER  Database
    Name of the Database to be backuped or restored
.PARAMETER BackupLocation
    The path to a directory on a filesystem. This shouldn't include a filename!
.PARAMETER RestoreFile
    The name of the backup file from which the database should be restored
.PARAMETER Task
    The task to perform with the script. Thsi is basically a 'backup' or 'restore' task.
.NOTES
    You need at least Powershell Version 2.0 to run this script!
.EXAMPLE
    ./backup_restore_db.ps1 -Task backup 
    Backup a database with all your defaults set in the script.
.EXAMPLE
    ./backup_restore_db.ps1 -Task restore -RestoreFile myDB-backup.bak
    Restore a database with all your defaults set in the script. 
#>
param(
    [Parameter(Mandatory=$false, 
               ValueFromPipeline=$true,
               ValueFromPipelineByPropertyName=$true)] 
    [string]$SQLServer = $env:COMPUTERNAME,

    [Parameter(Mandatory=$false, 
               ValueFromPipeline=$true,
               ValueFromPipelineByPropertyName=$true)] 
    [string]$Instance = "<InstanceName>", # put in your default

    [Parameter(Mandatory=$false, 
               ValueFromPipeline=$true,
               ValueFromPipelineByPropertyName=$true)] 
    [string]$Database = "<DatabaseName>", # put in your default

    [Parameter(Mandatory=$false, 
               ValueFromPipeline=$true,
               ValueFromPipelineByPropertyName=$true)] 
    [ValidateScript({Test-Path $_ -PathType 'Container'})]
    [string]$BackupLocation = "<BackupPath>", # put in your default

    [Parameter(Mandatory=$false, 
               ValueFromPipeline=$true,
               ValueFromPipelineByPropertyName=$true)] 
    [string]$RestoreFile,


    [Parameter(Mandatory=$true, 
               ValueFromPipeline=$true,
               ValueFromPipelineByPropertyName=$true)] 
    [ValidateSet("backup","restore")]
    [string]$Task

)
Import-Module SQLPS -DisableNameChecking

$Today = Get-Date -UFormat "%Y%m%d%H%M"
$Server = New-Object ("Microsoft.SqlServer.Management.Smo.Server") $SQLServer;
$Server.KillAllProcesses($Database);
$LogFile = "$BackupLocation\$Database-$Task.log".ToLower()

try
{
    if($Task.ToLower() -eq "backup")
    {
        $BFile = "$BackupLocation\$Database-$Today.bak"
        Backup-SqlDatabase -ServerInstance $SQLServer\$Instance `
                           -Database $Database `
                           -BackupFile $BFile `
                           -Verbose  4>&1 | #Attention!!! we redirect the verbose stream to stdout
        Write-Output -OutVariable out 
        Out-File $LogFile -InputObject($out) -Append -Force
    }
    elseif($Task.ToLower() -eq "restore")
    {
        $RFile = "$BackupLocation\$RestoreFile"
        if(Test-Path $RFile)
        {
            Restore-SqlDatabase -ServerInstance $SQLServer\$Instance `
                                -Database $Database `
                                -BackupFile $RFile `
                                -ReplaceDatabase `
                                -Verbose  4>&1 | #Attention!!! we redirect the verbose stream to stdout
            Write-Output -OutVariable out |
            Out-File $LogFile -InputObject($out) -Append -Force
        }
        else
        {
            Write-Output "$RFile doesn't exist!"
            Out-File $LogFile -InputObject("[error] $Today`: $RFile doesn't exist!") -Append -Force
        }
    }
    
}
catch 
{
    $ErrorMessage = $_.Exception.Message
    # since we get an eventlog to we simply plug an entry in the logfile, just be creative ;-)
    Out-File $LogFile -InputObject("[error] $Today`: $ErrorMessage") -Append -Force
}
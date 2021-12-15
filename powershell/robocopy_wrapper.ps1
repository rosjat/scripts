# Script:  robocopy_wrapper.ps1
# Author:  Markus Rosjat <markus.rosjat@gmail.com>
# Version: 1.0 
# Date:    2021-12-15 

<#
.SYNOPSIS 
   Simple Wrapper to get robocopy going with multiple source directories.
.DESCRIPTION
   Simple Wrapper to get robocopy going with multiple source directories. It will iterate over given
   source paths and copy them to the destionation path.
.PARAMETER SourcePath
    Array of strings, holding source directories, passed as argument to robocopy.
.PARAMETER DestinationPath
    A string holding the destination directory passed as argument to robocopy.
.PARAMETER Date
    A Date that can bespecified to build up a destination path for robocopy. This way we can store multiple copies.
.PARAMETER ExcludeDir
    Array of strings, holding directories to be excluded from a copy job, passed as argument to robocopy.
.PARAMETER RobocopyArgs
    Array of strings, holding Robocopy Arguments, passed as argument to robocopy. For all option check out the
	robocopy help.
.NOTES
    This is just a a wrapper for my needs, if you want more feel free to extend it!
.EXAMPLE
	PS > .\robocopy_wrapper.ps1 -SourcePath "d:\projects\project1", "D:\Projects\project2" -DestinationPath "W:\backup" -RobocopyArgs "/E", "/MT:10" -Date (Get-date)
#>
[CmdletBinding()]
Param
    (
        [string[]]$SourcePath,
		[string]$DestinationPath,
		[datetime]$Date = (Get-Date),
		[string[]]$ExcludeDir,
		[string[]]$RobocopyArgs

    )
$_Date = $Date.ToString("yyyyMMdd").Replace('.','')
if(!$(Test-Path $DestinationPath))
{
	New-Item -Path $DestinationPath -ItemType Directory 
}
foreach($from in $SourcePath)
{
	$to = Join-Path -Path $DestinationPath -Childpath $_Date  $(Split-Path $from -Leaf)
	$logfile = "$(Join-Path -Path $DestinationPath -Childpath $_Date)_$(Split-Path $from -Leaf).txt"

	if($ExcludeDir.Length -ne 0)
	{
	    robocopy $from $to $RobocopyArgs.Split() /XD $exclude.Split() > $logfile
	}
	else
	{
	    robocopy $from $to $RobocopyArgs.Split() > $logfile
	}
}
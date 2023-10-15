function Get-WindowsBackupLog() {
	[CmdletBinding(SupportsShouldProcess = $true)]
	param (
		[Parameter(Mandatory = $true, 
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			HelpMessage = "the computer name")] 
		[string[]]$ComputerName,

		[Parameter(Mandatory = $false,
			HelpMessage = "amount of days to get log, ")]
		[int]$TimeSpan = -8,

		[Parameter(Mandatory = $false)]
		[int[]]$EventID
	)
	BEGIN {
		Write-Verbose "Adding $EventID to $BackupEventId"
		$BackupEventId = @(4, 5, 9, 521, 7) + $EventID
	}
	PROCESS {
		foreach ($computer in $ComputerName) {

			if ($PSCmdlet.ShouldProcess('TARGET', 'OPERATION')) {
				$Logs = Get-WinEvent -ComputerName $computer @{logname = 'Microsoft-Windows-Backup'; starttime = [datetime]::today.AddDays($TimeSpan) }  | 
				Where-Object { $_.id -in $BackupEventId }
			}

			foreach ($Log in $Logs) { 
				Write-Output New-LogObject -ComputerName $computer -Log $Log 
			}

		}
	}
	END {}
}

function Get-SystemEventLog() {
	[CmdletBinding(SupportsShouldProcess = $true)]
	param (
		[Parameter(Mandatory = $true, 
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			HelpMessage = "the computer name")] 
		[string[]]$ComputerName,

		[Parameter(Mandatory = $false,
			HelpMessage = "amount of days to get log, ")]
		[int]$TimeSpan = -8,

		[Parameter(Mandatory = $false)]
		[int[]]$LogLevel = @(2, 3),

		[Parameter(Mandatory = $false)]
		[int[]]$ExcludeEventID
	)
	BEGIN {
		Write-Verbose "Adding $ExcludeEventID to $noise"
		$Noise = @(3, 10028, 9220, 1023) + $ExcludeEventID
	}
	PROCESS {
		foreach ($computer in $ComputerName) {

			if ($PSCmdlet.ShouldProcess('TARGET', 'OPERATION')) {
				$Logs = Get-WinEvent -ComputerName $computer @{logname = 'system'; starttime = [datetime]::today.AddDays($TimeSpan); level = $LogLevel }  | 
				Where-Object { $_.id -notin $Noise }
			}
			foreach ($Log in $Logs) { 
				Write-Output New-LogObject -ComputerName $computer -Log $Log 
			}

		}
	}
	END {}
}
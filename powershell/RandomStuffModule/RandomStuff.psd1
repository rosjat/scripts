#
# Module manifest for module 'RandomStuff'
#
# Generated by: Markus Rosjat
#
# Generated on: 13.10.2023
#

@{

	# Script module or binary module file associated with this manifest.
	RootModule        = '.\RandomStuffModule.Cmdlet.dll'

	# Version number of this module.
	ModuleVersion     = '0.2.0'

	# ID used to uniquely identify this module
	GUID              = '55165755-eadc-4fa0-8134-124cece73cf2'

	# Author of this module
	Author            = 'Markus Rosjat'
	CompanyName       = ''
	Copyright         = '(c) Markus Rosjat. All rights reserved.'

	# Description of the functionality provided by this module
	# Description = ''

	# Minimum version of the PowerShell engine required by this module
	PowerShellVersion = '7.0'
	# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
	CmdletsToExport   = @(
		'New-TimeServer', 
		'Get-TimeServer',
		'Set-TimeServer',
		'Remove-TimeServer'
	)

}


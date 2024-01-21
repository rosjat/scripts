# Script:  make.ps1
# Author:  Markus Rosjat <markus.rosjat@gmail.com>
# Version: 1.0 
# Date:    2024-01-21

<#
.SYNOPSIS 
   Simple Script to run some Docker Commands to migrate Owncloud to Nextcloud 
.DESCRIPTION

.PARAMETER Prestage
    A switch to build the prestage docker image
.PARAMETER Build
    A switch to build a baseX docker image
.PARAMETER BuildImages
    A switch to build all the baseX docker images
.PARAMETER Migrate
    A switch to run one migration stage
.PARAMETER All
    A switch to run all migration stages
.PARAMETER Version
    A string to define the version of the image to be build
.PARAMETER Base
    A string to the fine the base image to be build
.PARAMETER NcVersion
    A string to define the Nextcloud version to migrate to
.PARAMETER NcVersions
    A string array with all versions you want to migrate through
.NOTES
    It's not perfect so feel free to improve!
.EXAMPLE
	PS > .\make.ps1 -All 
.EXAMPLE
	PS > .\make.ps1 -Prestage
.EXAMPLE
	PS > .\make.ps1 -BuildImages -Version 0.1
.EXAMPLE
	PS > .\make.ps1 -Build -Base 16 -Version 0.1
.EXAMPLE
	PS > .\make.ps1 -Migrate -Base 16 -Version 0.1 -NcVersion 13.0.0
#>
[CmdletBinding()]
Param
(
	[Parameter(ValueFromPipeline = $true,
		ParameterSetName = "Prestage")] 
	[switch]$Prestage,
	[Parameter(ValueFromPipeline = $true,
		ParameterSetName = "Migrate")]
	[switch]$Migrate,
	[Parameter(ValueFromPipeline = $true,
		ParameterSetName = "Build")]
	[switch]$Build,
	[Parameter(ValueFromPipeline = $true,
		ParameterSetName = "BuildImages")]
	[switch]$BuildImages,
	[Parameter(ValueFromPipeline = $true,
		ParameterSetName = "All")]
	[switch]$All,
	[Parameter(ValueFromPipeline = $true,
		ParameterSetName = "Migrate")]
	[Parameter(ValueFromPipeline = $true,
		ParameterSetName = "Build")]
	[Parameter(ValueFromPipeline = $true,
		ParameterSetName = "BuildImages")]
	[Parameter(ValueFromPipeline = $true,
		ParameterSetName = "All")]
	[string]$Version = "0.1",
	[Parameter(ValueFromPipeline = $true,
		ParameterSetName = "Migrate")]
	[Parameter(ValueFromPipeline = $true,
		ParameterSetName = "Build")]
	[Parameter(ValueFromPipeline = $true,
		ParameterSetName = "BuildImages")]
	[Parameter(ValueFromPipeline = $true,
		ParameterSetName = "All")]
	[string]$Base = "16",
	[Parameter(ValueFromPipeline = $true,
		ParameterSetName = "Migrate")]
	[string]$NcVersion = "12.0.4",
	[Parameter(ValueFromPipeline = $true,
		ParameterSetName = "All")]
	[string[]]$NcVersions = @("12.0.4", "13.0.0", "14.0.0", "15.0.0", "16.0.10", "17.0.10", "18.0.14", "19.0.13", "20.0.14", "21.0.9", "22.2.10", "23.0.12", "24.0.12", "25.0.13", "26.0.10", "27.1.5", "28.0.1")
)

if ($Prestage.IsPresent) {
	docker build --target prepstage --progress=plain  -t migration:prepstage .
}
if ($Migrate.IsPresent) {
	docker run --rm --env-file $PWD/env/base.env --env-file "$PWD/env/base$Base.env"  -e NC_VERSION="$NcVersion" -v $PWD/:/owncloud migration:$($Base)v$Version
}
if ($Build.IsPresent) {
	docker build --target base$Base --progress=plain  -t migration:$($Base)v$Version  .
}
if ($BuildImages.IsPresent) {
	foreach ($ver in @("16", "18", "20", "22")) {
		docker build --target base$ver --progress=plain  -t migration:$($ver)v$Version  .
	}
}
if ($All.IsPresent) {
	$b = "16"
	foreach ($ver in $NcVersions) {
		if ( @("12.0.4", "13.0.0") -contains $ver) {
			$b = "16"
		}
		if ( @("14.0.0", "15.0.0", "16.0.10", "17.0.10", "18.0.14", "19.0.13") -contains $ver) {
			$b = "18"
		}
		if ( @("20.0.14", "21.0.9", "22.2.10", "23.0.12", "24.0.12") -ccontains $ver) {
			$b = "20"
		}
		if ( @("25.0.13", "26.0.10", "27.1.5", "28.0.1") -ccontains $ver) {
			$b = "22"
		}
		docker run --rm --env-file $PWD/env/base.env --env-file "$PWD/env/base$b.env"  -e NC_VERSION="$ver" -v $PWD/:/owncloud migration:$($b)v$Version
	}
}
# Script:  hp_cim.ps1
# Author:  Markus Rosjat <markus.rosjat@gmail.com>
# Version: 0.0.1
# Date:    2016-11-11

function Write-HPCim
{
    <#
    .SYNOPSIS 
       CmdLet to get HP CIM Classes installed with the HP WEBM Providers. 
    .DESCRIPTION
       The CmdLet prints out properties of a given class/classes. It only prints 
       Properties with a value! so it can't be assumed that all properties of a 
       class will be printed out! This Function is basically a way to get an overview  
       of all the things HP drops on your server that you might want to utilize for 
       your monitoring.
    .PARAMETER ComputerName
        A List of Strings representing Computernames.
    .PARAMETER NameSpace
        A List of Strings representing HP CIM Namespaces.
    .PARAMETER  Class
        A List of Strings representing HP CIM Classes. IF Class is not provides
        the CmdLet will Query all HP CIM classes in the given Namespace!
    .Note
        You need to install HP WEBM Providers first (cp027592.exe) 
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)] 
        [string[]]$ComputerName ,

        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)] 
        [string[]]$NameSpace,

        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=2)] 
        [string[]]$Class
    )
    begin
    {

    }

    process
    {
        foreach($Computer in $ComputerName)
        {
            foreach($NS in $NameSpace)
            {
                if($Class -eq $null)
                {
                    $Class = @()
                    foreach($c in (Get-CimClass HP_* -Namespace $NS))
                    {
                        $Class += ,$c.CimClassName
                    }
                }
                foreach($Cls in $Class)
                {
                    $CIMCollection = Get-WMIObject -class $Cls -namespace $NS -computername $Computer
                    Write-Output "--------- Start $Cls ---------"
                    foreach ($CIMObject in $CIMCollection) 
                    {
                        Write-Output "`t--------- Start Property Check for $($CIMObject.Name) ---------"
                        foreach($prop in (Get-Member -InputObject $CIMObject -MemberType Property))
                        {
                            $val = $CIMObject."$($prop.Name)"
                            $name = $($prop.Name)
                           if($val -ne $null -and $name.StartsWith("__") -eq $false)
                           {
                                Write-Output "`t`t$name -> $val"
                           }
                        }
                        Write-Output "`t----------- End Property Check for $($CIMObject.Name) ---------------"
                    }
                    Write-Output "--------- Start $Cls ---------"
                }
            }
        }
    }

}

function Write-HPCimToFile
{
    <#
    .SYNOPSIS 
       CmdLet to write HP CIM Classes installed with the HP WEBM Package to a file.
       This Function is basically a way to write out to afile an overview  of all 
       the things HP drops on your server that you might want to utilize for your
       monitoring. 
    .DESCRIPTION
       The CmdLet writes the output  Write-HPCim to a file.
    .PARAMETER ComputerName
        A List of Strings representing Computernames.
    .PARAMETER NameSpace
        A List of Strings representing HP CIM Namespaces.
    .PARAMETER  Class
        A List of Strings representing HP CIM Classes. IF Class is not provides
        the CmdLet will Query all HP CIM classes in the given Namespace!
    .PARAMETER  Path
        Location on the filesystem to store the created files.
    .Note
        You need to install HP WEBM Providers first (cp027592.exe)         
    .Example
        Creates  files in C:\HPQ like hp_cim_My_awesome_server_namespace_root_hpq.txt

        $Computers = "My_awesome_server"
        $Namespaces = "root\hpq", "root\hpq\default", "root\interop"
        $FilePath = "C:\HPQ"

        Write-HPCimToFile $Computers $Namespaces -Path $FilePath

        
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)] 
        [string[]]$ComputerName ,

        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)] 
        [string[]]$NameSpace,

        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=2)] 
        [string[]]$Class,

        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=3)] 
        [string[]]$Path

    )
    begin
    {

    }

    process
    {
        foreach($Computer in $ComputerName)
        {
            foreach($NS in $NameSpace)
            {
                Write-HPCim $Computer $NS $Class | Out-File -FilePath "$Path\hp_cim_$($Computer)_namespace_$($NS.Replace('\','_')).txt"
            }
        }
    }

}
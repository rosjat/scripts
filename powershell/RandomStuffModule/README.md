Cmdlet Module for RandomStuff
==============================

Not much to see here for now but it will try to make some of the scripts available as Cmdlets in this module.
The Module is written in C# and the .csproj file was created for a .netstandard2.0 version but I switched to .net6 since the commands are aimed to be used with windows anyway.

The build stuff is more or less dotnet cli and I will add it as soon as possible but there are many resources on the net that tell you how to build it.

Content
--------

* TimeServer.cs - a static class that does the heavy lifting with the windows registry
* RegeditEnty.cs - a class that acts as an output object, this might get renamed in the future ...
* NewTimeServerCommand.cs - Cmdlet class that holds the functionality of timeserver.ps1 
* GetTimeServerCommand.cs - Cmdlet class that holds the functionality to retrive a specific regitry entry for a time server or all entries
* SetTimeServerCommand.cs - Cmdlet class that holds the functionality to Set a new value for an existing entry
* RemoveTimeServerCommand.cs - Cmdlet class that holds the functionality to remove an exisiting entry
* ExportPuttySettingCommand.cs - Cmdlet class that holds the functionality to export registry entries for the putty tool

Build
---------

used the build.ps1 to run the dotnet commands to build the dll and create a folder .publish to get everything to import the module. the publish folder could
be placed in the $PSModulePath so the module will be found by Powershel. For this to work remove # in the following lines and run the script with elevated rights.

    # ($env:PSModulePath).split(";") | Select-String -Pattern "powershell\\7"  -OutVariable destinationPath
    # if (-Not (Test-Path $destinationPath\RandomStuff)) { New-Item -ItemType Directory -Path $destinationPath -Name RandomStuff }
    # Copy-Item ".\publish\*"  -Destination "$destinationPath\RandomStuff" -Recurse -Force -Exclude "*.pdb", "*.json"

Commandlets
-------------

* New-TimeServer
* Get-TimeServer
* Set-TimeServer
* Remove-TimeServer
* Export-PuttySetting

ToDo
--------

* Add testing
* Try to figure out if this all works with pipelines
* Add Documentation that gets displayed with Get-Help 
* Figure out if the project structure is best practice for binary powershell modules in c#
#build and publish
dotnet build --configuration Release .\RandomStuffModule.Cmdlet\ --output .\build
dotnet publish --configuration Release .\RandomStuffModule.Cmdlet\ --output .\publish
Copy-Item .\RandomStuff.psd1 .\publish -Force


# move to ModulePath
($env:PSModulePath).split(";") | Select-String -Pattern "powershell\\7"  -OutVariable destinationPath
if (-Not (Test-Path $destinationPath\RandomStuff)) { New-Item -ItemType Directory -Path $destinationPath -Name RandomStuff }
Copy-Item ".\publish\*"  -Destination "$destinationPath\RandomStuff" -Recurse -Force -Exclude "*.pdb", "*.json"

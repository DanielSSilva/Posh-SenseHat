# Posh-SenseHat
This repository allows interaction with the raspberry SenseHat via PowerShell.

There's currently a fully working version, although it's implemented in C#.

How to use:

* Publish the solution (change to the solution folder: dotNetFullImplementation\SenseHatPowerShell) : `dotnet publish -r linux-arm`
* Copy the `publish` folder located at `dotNetFullImplementation\SenseHatPowerShell\bin\Debug\netcoreapp2.0\linux-arm\publish\`
* Launch PowerShell and do `Import-Module path/to/your/publish/SenseHatPowerShell.dll`
* Init the senseHat by doing `$senseHat = [SenseHatPowerShell.CoreDeviceFactory]::InitAndGetIt()`
* From here one, use this object to interact with sensors/display/etc

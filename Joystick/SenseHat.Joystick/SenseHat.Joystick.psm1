#####
# Private functions

Function GetSenseHatJoystick {
    $DeviceBasePath = '/dev/input/'
    
    $InputDevices = Get-ChildItem -Path "/sys/class/input/event*"
    Try {
        foreach ($device in $InputDevices) {
            $Event = Split-path $Device -Leaf
            $FileIndexer = "$Device/device/name"
            if ( (Get-Content -Path $FileIndexer) -eq 'Raspberry Pi Sense HAT Joystick') {
                Join-Path -Path $DeviceBasePath -ChildPath $Event
            }
        }
    }
    catch {
        Write-Error 'Failed to find SenseHat Joystick.'
    }
}

#####
# Public functions

Function Get-SenseHatJoysticButton {
    $Joystick = GetSenseHatJoystick
    
    $Button = Get-Content -AsByteStream -Path $joystick -TotalCount 11
    
    Switch ($Button[-1]) { 
        103 {'up'}
        105 {'left'}
        106 {'right'}
        108 {'down'}
        28 {'enter'}
    }
}

# Export only the functions using PowerShell standard verb-noun naming.
# Be sure to list each exported functions in the FunctionsToExport field of the module manifest file.
# This improves performance of command discovery in PowerShell.
Export-ModuleMember -Function *-*

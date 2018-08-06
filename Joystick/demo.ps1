Import-Module .\SenseHat.Joystick
Import-Module ..\LedMatrix\PowerShell\SenseHat.Matrix


$IndexColor = 1
$IndexValue = 15

Set-MatrixWithSingleColor -Red $IndexValue -Green 0 -Blue 0

While ($true){
    $ButtonClicked = Get-SenseHatJoysticButton
    Switch ($ButtonClicked) {
        'up' { 
            $IndexValue++ 
            if ($IndexValue -ge 31) {
                $IndexValue = 31
            }
        }
        'down' { 
            $IndexValue--
            if ($IndexValue -lt 0) {
                $IndexValue = 0
            }
        }
        
        'left' {
            $IndexColor--
            if ($IndexColor -lt 0) {
                $Indexcolor = 0
            }
        }

        'right' {
            $IndexColor++
            if ($IndexColor -ge 3) {
                $Indexcolor = 3
            }
        }
        
        'enter' {
            Set-MatrixWithSingleColor -Red 0 -Green 0 -Blue 0
            throw 'Im out!'
        }
    }

    switch ($IndexColor) {
        1 {Set-MatrixWithSingleColor -Red $IndexValue -Green 0 -Blue 0}
        2 {Set-MatrixWithSingleColor -Red 0 -Green $IndexValue -Blue 0}
        3 {Set-MatrixWithSingleColor -Red 0 -Green 0 -Blue $IndexValue}
    }
    
    Start-Sleep -Seconds 1
}

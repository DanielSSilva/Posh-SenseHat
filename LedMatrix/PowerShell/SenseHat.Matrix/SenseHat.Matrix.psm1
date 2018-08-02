#####
# Private functions

Function WritebyteArrayToMatrix {
    Param(
        [Parameter(Mandatory = $true)]
        [Byte[]]$PixelList
    )

    $Writer = [System.IO.BinaryWriter]::new([System.IO.File]::Open('/dev/fb1', [System.IO.FileMode]::Open))
    
    for ($i = 0 ; $I -lt $PixelList.Length  ; $i ++) { 
        $Null = $Writer.Seek($i, [System.IO.SeekOrigin]::Begin) 
        $Null = $Writer.Write([byte]$PixelList[$i]) 
    }

    $Writer.Close()
    $Writer.Dispose()
}

Function ConvertToByteArray{ 
    param(
        [UInt16[]]$source
    )

    [byte[]]$arrayAsByte = New-Object -TypeName Byte[] -ArgumentList ($source.Length * 2)

    [System.Buffer]::BlockCopy($source, 0, $arrayAsByte, 0, $arrayAsByte.Length)
    $arrayAsByte
}

#####
# Public functions

Function Set-MatrixWithRainbow {
    $Color = [UInt16]32768
    [UInt16[]]$PixelList = $Color
    1..15 | foreach {
        $PixelList += $Color -bor ($Color -shr 1)
        $Color = $PixelList[-1]
    }
    1..16 | foreach {
        $PixelList += $Color -shr 1
        $Color = $PixelList[-1]
    }
    
    [UInt16[]]$PixelList += $PixelList[($PixelList.Length -1)..0]
    
    $PixelListByte = ConvertToByteArray -source $PixelList
    WritebyteArrayToMatrix -PixelList $PixelListByte
}

Function Set-MatrixWithSingleColor { 
    Param(
        [Parameter(Mandatory = $true, 
            ValueFromPipeline = $true, 
            ValueFromPipelineByPropertyName = $true, 
            Position = 0
        )]
        [ValidateRange(0,31)]
        [UInt16]$Red,

        [Parameter(Mandatory = $true, 
            ValueFromPipeline = $true, 
            ValueFromPipelineByPropertyName = $true, 
            Position = 0
        )]
        [ValidateRange(0,63)]
        [UInt16]$Green,

        [Parameter(Mandatory = $true, 
            ValueFromPipeline = $true, 
            ValueFromPipelineByPropertyName = $true, 
            Position = 0
        )]
        [ValidateRange(0,31)]
        [UInt16]$Blue
    )

    Begin {
        $PixelListInt = @()
    }

    Process {
        for ($I = 0 ; $I -lt 64 ; $I++ ) {
            [UInt16[]]$PixelListInt += [UInt16]( ([UInt16]$Red -shl 11) -bor ([UInt16]$Green -shl 5) -bor ([UInt16]$Blue) )
        }

        Try {
            $PixelListByte = ConvertToByteArray -source $PixelListInt
            WritebyteArrayToMatrix -PixelList $PixelListByte
        }
        catch {
            Write-Error 'Failed to write output to screen.'
        }
    }
}


# Export only the functions using PowerShell standard verb-noun naming.
# Be sure to list each exported functions in the FunctionsToExport field of the module manifest file.
# This improves performance of command discovery in PowerShell.
Export-ModuleMember -Function *-*

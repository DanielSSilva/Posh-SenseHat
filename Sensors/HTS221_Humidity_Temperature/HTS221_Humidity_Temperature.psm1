$deviceAddress = 0x5F
$Device = Get-I2CDevice -Id $deviceAddress -FriendlyName tempSensor	

function Set-SampleAmount{
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true)]
		[ValidateSet(2,4,8,16,32,64,128,256)]
		[int]$numberOfSamples
	)
	$samplePossibilities = @{
		2 	= [convert]::toint32('000',2)
		4	= [convert]::toint32('001',2)
		8 	= [convert]::toint32('010',2)
		16 	= [convert]::toint32('011',2)
		32 	= [convert]::toint32('100',2)
		64 	= [convert]::toint32('101',2)
		128 = [convert]::toint32('110',2)
		256 = [convert]::toint32('111',2)
	}
	$ConfigureAverageValue = $samplePossibilities[$numberOfSamples]
	$ConfigureAverageAddress = 0x10
	Set-I2CRegister -Device $Device -Register $ConfigureAverageAddress -Data $ConfigureAverageValue
}

$controlRegisterAddress = 0x20
$controlRegisterValue = 0x84
Set-I2CRegister -Device $Device -Register $controlRegisterAddress -Data $controlRegisterValue

function CheckIfDataExists () {
	$checkIfNewDataRegisterAddress = 0x27
	(Get-I2CRegister -Device $Device -Register $checkIfNewDataRegisterAddress).Data
}

function Get-NewSample(){
	$requestNewSampleRegisterAddress = 0x21
	$requestNewSampleRegisterValue = 0x83

	Set-I2CRegister -Device $Device -Register $requestNewSampleRegisterAddress -Data $requestNewSampleRegisterValue
}


##################### TEMPERATURE ###########################
function Read-TemperatureSample(){
	$tempLowRegisterAddress = 0x2A
	$tempHighRegisterAddress = 0x2B 
	#READ VALUES
	[int16]$temperatureOutL = (Get-I2CRegister -Device $Device -Register $tempLowRegisterAddress).Data[0]
	[int16]$temperatureOutH = (Get-I2CRegister -Device $Device -Register $tempHighRegisterAddress).Data[0]
	[int16]($temperatureOutH -shl 8) -bor $temperatureOutL
}

function Get-T0_degC_x8(){
	$lsbTemperatureCalibrationRegisterAddress = 0x32
	$msbTemperatureCalibrationRegisterAddress = 0x35

	[int16]$lsb = (Get-I2CRegister -Device $Device -Register $lsbTemperatureCalibrationRegisterAddress).Data[0]
	[int16]$msb = ((Get-I2CRegister -Device $Device -Register $msbTemperatureCalibrationRegisterAddress).Data[0]) -band 0x03 # 0011

	[int16]($msb -shl 8) -bor $lsb
}

function Get-T1_degC_x8(){
	$lsbTemperatureCalibrationRegisterAddress = 0x33
	$msbTemperatureCalibrationRegisterAddress = 0x35

	[int16]$lsb = (Get-I2CRegister -Device $Device -Register $lsbTemperatureCalibrationRegisterAddress).Data[0]
	[int16]$msb = ((Get-I2CRegister -Device $Device -Register $msbTemperatureCalibrationRegisterAddress).Data[0]) -band 0x0C # 1100
	$msb = $msb -shr 2 # we need to shift twice because it was on the 3rd and 4th position, wee need to be on 1st and 2nd

	[int16](($msb -shl 8) -bor $lsb)
}

function Get-T0_OUT(){
	[int16]$registerAddressL = 0x3C 
	[int16]$registerAddressH = 0x3D

	[int16]$lsb = (Get-I2CRegister -Device $Device -Register $registerAddressL).Data[0]
	[int16]$msb = (Get-I2CRegister -Device $Device -Register $registerAddressH).Data[0]

	[Int16]($msb -shl 8) -bor $lsb
}

function Get-T1_OUT(){
	$registerAddressL = 0x3E 
	$registerAddressH = 0x3F

	[int16]$lsb = (Get-I2CRegister -Device $Device -Register $registerAddressL).Data[0]
	[int16]$msb = (Get-I2CRegister -Device $Device -Register $registerAddressH).Data[0]

	[Int16]($msb -shl 8) -bor $lsb
}

function Get-CurrentTemperature(){
	[int16]$T_OUT 	= Read-TemperatureSample
	[int16]$T0_OUT 	= Get-T0_OUT
	[int16]$T1_OUT 	= Get-T1_OUT
	[int16]$T0_DegC = (Get-T0_degC_x8)/8
	[int16]$T1_DegC = (Get-T1_degC_x8)/8
	$calcTemperature = ( ($T_OUT - $T0_DegC)*($T1_DegC - $T0_DegC) / ($T1_OUT - $T0_OUT)) + $T0_DegC
	$temperature = [math]::Round($calcTemperature)
	$temperature
}

# Export only the functions using PowerShell standard verb-noun naming.
# Be sure to list each exported functions in the FunctionsToExport field of the module manifest file.
# This improves performance of command discovery in PowerShell.
Export-ModuleMember -Function *-*

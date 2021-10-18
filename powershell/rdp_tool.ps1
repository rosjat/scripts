# Script:  rdp_tool.ps1
# Author:  Markus Rosjat <markus.rosjat@gmail.com>
# Version: 1.0 
# Date:    2021-10-18 

Add-Type -AssemblyName System.Windows.Forms

function Get-PresetIndexByName {
	param (
		$Preset,
		$SearchString
	)
	foreach($item in $Preset)
	{
		if($item[0] -like $SearchString) {
			return $Preset.IndexOf($item)
		}
	}
}

function New-RdpFile {
	$i = Get-PresetIndexByName $preset "Rechner*"
    $pc = (Get-Variable TB$i).Value.Text.Trim()
    Test-Connection $pc -OutVariable ping
    if ($ping.Count -eq 0) {
        $ip = $pc
    }
    else {
        $ip = $ping.Address[0].IPAddressToString
    }
	$i = Get-PresetIndexByName $preset "Nutzer*"
    $user = (Get-Variable TB$i).Value.Text.Trim()
	$i = Get-PresetIndexByName $preset "Domain*"
    $domain = (Get-Variable TB$i).Value.Text.Trim()
	$i = Get-PresetIndexByName $preset "Passwort*"
    $pw = (Get-Variable TB$i).Value.Text | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString
    $path = "$($env:USERPROFILE)\Desktop\$pc.rdp"
    Remove-Item $path -ErrorAction Ignore
    "screen mode id:i:2
    use multimon:i:0
    desktopwidth:i:1680
    desktopheight:i:1050
    session bpp:i:32
    winposstr:s:0,1,0,0,816,639
    compression:i:1
    keyboardhook:i:2
    audiocapturemode:i:0
    videoplaybackmode:i:1
    connection type:i:7
    networkautodetect:i:1
    bandwidthautodetect:i:1
    displayconnectionbar:i:1
    enableworkspacereconnect:i:0
    disable wallpaper:i:0
    allow font smoothing:i:0
    allow desktop composition:i:0
    disable full window drag:i:1
    disable menu anims:i:1
    disable themes:i:0
    disable cursor setting:i:0
    bitmapcachepersistenable:i:1
    full address:s:$ip
    audiomode:i:0
    redirectprinters:i:0
    redirectcomports:i:0
    redirectsmartcards:i:0
    redirectclipboard:i:0
    redirectposdevices:i:0
    autoreconnection enabled:i:1
    authentication level:i:2
    prompt for credentials:i:0
    negotiate security layer:i:1
    remoteapplicationmode:i:0
    alternate shell:s:
    shell working directory:s:
    gatewayhostname:s:
    gatewayusagemethod:i:4
    gatewaycredentialssource:i:4
    gatewayprofileusagemethod:i:0
    promptcredentialonce:i:0
    gatewaybrokeringtype:i:0
    use redirection server name:i:0
    rdgiskdcproxy:i:0
    kdcproxyname:s:
    drivestoredirect:s:
    username:s:$domain\$user
    password 51:b:$pw
    " | Out-File -FilePath $path -Append
}

$preset = @(
	@('Domain:', $env:USERDOMAIN),
	@('Rechner:', ''),
	@('Nutzer:', $env:USERNAME),
	@('Passwort:', '')
)


# Create a new form
$Form                    = New-Object system.Windows.Forms.Form
$Form.ClientSize         = '500,180'
$Form.text               = "RDP File Creator"
$Form.BackColor          = "#ffffff"
$Form.FormBorderStyle    = [System.Windows.Forms.FormBorderStyle]::Fixed3D

for($i = 0; $i -lt $preset.count; $i++) {
	if ((Test-Path variable:Lbl$i) -eq $false) {
		New-Variable "Lbl$i"  
	}
	(Get-Variable Lbl$i).Value = New-Object system.Windows.Forms.Label
	(Get-Variable Lbl$i).Value.text                     = $preset[$i][0]
	(Get-Variable Lbl$i).Value.AutoSize                 = $true
	(Get-Variable Lbl$i).Value.width                    = 25
	(Get-Variable Lbl$i).Value.height                   = 20
	(Get-Variable Lbl$i).Value.location             	= New-Object System.Drawing.Point(10,(30 * $i))
	(Get-Variable Lbl$i).Value.Font                     = 'Microsoft Sans Serif,13'
	
	if ((Test-Path variable:TB$i) -eq $false) {
		New-Variable "TB$i"  
	}
	(Get-Variable TB$i).Value                     		= New-Object system.Windows.Forms.TextBox
	(Get-Variable TB$i).Value.multiline           		= $false
	(Get-Variable TB$i).Value.width               		= 390
	(Get-Variable TB$i).Value.height              		= 20
	(Get-Variable TB$i).Value.location        			= New-Object System.Drawing.Point(100,(30 * $i))
	(Get-Variable TB$i).Value.Font                		= 'Microsoft Sans Serif,10'
	(Get-Variable TB$i).Value.Visible             		= $true
	(Get-Variable TB$i).Value.Text                		= $preset[$i][1]
	if ($preset[$i][0] -like "Passwort*" ) {
		(Get-Variable TB$i).Value.PasswordChar    		= "*"
	}

	$Form.Controls.AddRange(@((Get-Variable Lbl$i).Value, (Get-Variable TB$i).Value ))
}

# Create a Button
$Btn                   = New-Object system.Windows.Forms.Button
$Btn.BackColor         = "#a4ba67"
$Btn.text              = "Erstelle RDP Datei"
$Btn.width             = 480
$Btn.height            = 30
$Btn.location          = New-Object System.Drawing.Point(10,140)
$Btn.Font              = 'Microsoft Sans Serif,10'
$Btn.ForeColor         = "#ffffff"
$Btn.Add_Click({ New-RdpFile })

$Form.Controls.Add($Btn)

[void]$Form.ShowDialog()
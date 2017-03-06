# move all shares with a shared folder that matches $oldDriveSpec to a new folder location
# reboot windows after the script completed to apply changes

$oldRoot = "C:\DDTP\Datalanding"
$oldDriveSpec = "^E:\\"
$newRoot = "K:\DDTP\DataLanding"
$newDriveSpec = "K:\"

function Change-SharePath {
    [cmdletbinding(SupportsShouldProcess=$true)]
    param(
        $OldPath,
        $NewPath
    )
    
    $RegPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Shares'
    dir -Path $RegPath | Select-Object -ExpandProperty Property | ForEach-Object {
        $ShareName = $_
        # "Testing sharename ($ShareName)"
        $ShareData = Get-ItemProperty -Path $RegPath -Name $ShareName |
                Select-Object -ExpandProperty $ShareName

        if ($ShareData | Where-Object { $ShareData -contains "Path=$OldPath"}) {
            # "Found path ($OldPath)"
            $ShareData = $ShareData -replace [regex]::Escape("Path=$OldPath"), "Path=$NewPath"
            if ($PSCmdlet.ShouldProcess($ShareName, 'Change-SharePath')) {
                "Replacing with new ShareData: $ShareData"
                 Set-ItemProperty -Path $RegPath -Name $ShareName -Value $ShareData
            }
        }
    }
}

$shares = gwmi Win32_Share
foreach($share in $shares) {
    if ($share.Path.StartsWith($oldRoot,"CurrentCultureIgnoreCase") -and $share.Path -ne $oldRoot)
    {
        $newPath = $share.Path -replace $oldDriveSpec, $newDriveSpec
        "About to replace $($share.Path) with $newPath"
        Change-SharePath -OldPath $share.Path -NewPath $newPath
    }
}

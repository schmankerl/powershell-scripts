# Json File Path
$sshProfiles = Get-Content -Path "" -Raw | ConvertFrom-Json

function Connect-SSHProfile($profileName) {
    $sshProfile = $sshProfiles | Where-Object { $_.Name -eq $profileName }
    if ($sshProfile) {
        $sshCommand = "ssh.exe $($sshProfile.Username)@$($sshProfile.Hostname)"
        if ($sshProfile.Port) { $sshCommand += " -p $($sshProfile.Port)" }

        Write-Host "Connecting to $($sshProfile.Name)..."
        Invoke-Expression $sshCommand
    } else {
        Write-Error "Profile does not exist: $profileName"
    }
}

function Get-SSHProfiles {
    Write-Host "SSH Profiles:"
    $sshProfiles | ForEach-Object {
        Write-Host " - $($_.Name) ($($_.Username)@$($_.Hostname):$($_.Port))"
    }
}
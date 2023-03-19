#Function which either opens the current/specified profile or creates a new one if it does not exist
function Edit-Profile {
    param (
        [string]$Name = "Current User"
    )
    
    $profilePath = $profile -replace "\\.ps1$",".ps1"
    
    if (!(Test-Path $profilePath)) {
        New-Item -ItemType File -Path $profilePath -Force | Out-Null
    }
    
    $notepadPath = Join-Path $env:SystemRoot "notepad.exe"
    Start-Process $notepadPath -ArgumentList $profilePath
}
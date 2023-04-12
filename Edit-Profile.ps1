#Function which either opens the current/specified profile or creates a new one if it does not exist
#Needs to have $env:EDITOR variable set in order for this to work
function Edit-Profile 
{
    param ([string]$Name = "Current User")
    
    $profilePath = $profile -replace "\\.ps1$",".ps1"
    
    if (!(Test-Path $profilePath)) 
    {
        New-Item -ItemType File -Path $profilePath -Force | Out-Null
    }
    
    $editorCommand = $env:EDITOR
    if ([string]::IsNullOrWhiteSpace($editorCommand)) 
    {
        $editorCommand = "notepad.exe"
    }
    
    Start-Process $editorCommand -ArgumentList $profilePath
}

#Usage
#Edit-Profile -Name [POWERSHELL_PROFILE_NAME]

function Edit-Profile 
{
    param ([string]$Name = "Current User")
    
    $profilePath = $profile -replace "\\.ps1$",".ps1"
    
    if (!(Test-Path $profilePath)) 
    {
        New-Item -ItemType File -Path $profilePath -Force | Out-Null
    }
    
    $notepadPath = Join-Path $env:SystemRoot "notepad.exe"
    Start-Process $notepadPath -ArgumentList $profilePath
}

#Usage
#Edit-Profile -Name [POWERSHELL_PROFILE_NAME]
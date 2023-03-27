# Define a function to list all SSH profiles
function Get-SSHProfiles 
{
    Write-Host "SSH Profiles:"
    $sshProfiles | ForEach-Object 
    {
        Write-Host " - $($_.Name) ($($_.Username)@$($_.Hostname):$($_.Port))"
    }
}
function Set-SSHProfile 
{
    param
    (
        [Parameter(Mandatory=$true)]
        [ValidateSet('add', 'edit', 'delete')]
        [string]$action,

        [Parameter(Mandatory=$true)]
        [string]$name,

        [Parameter(Mandatory=$false)]
        [string]$hostname,

        [Parameter(Mandatory=$false)]
        [string]$username,

        [Parameter(Mandatory=$false)]
        [int]$port = 22,

        [Parameter(Mandatory=$true)]
        [string]$configFilePath
    )

    $sshProfiles = Get-Content -Path $configFilePath -Raw | ConvertFrom-Json

    if ($action -eq 'add') 
    {
        if ($sshProfiles -ne $null -and ($sshProfiles | Where-Object { $_.Name -eq $name })) 
        {
            Write-Error "A profile with name '$name' already exists."
            return
        }
        $sshProfile = @{ Name=$name; Hostname=$hostname; Username=$username; Port=$port }
        $sshProfiles += $sshProfile
        Write-Host "Profile '$name' added."
    }

    if ($action -eq 'edit') 
    {
        $profileIndex = ($sshProfiles | ForEach-Object { $_.Name }).IndexOf($name)
        if ($profileIndex -eq -1) 
        {
            Write-Error "No profile found with name '$name'."
            return
        }
        if ($hostname) { $sshProfiles[$profileIndex].Hostname = $hostname }
        if ($username) { $sshProfiles[$profileIndex].Username = $username }
        if ($port -ne 22) { $sshProfiles[$profileIndex].Port = $port }
        Write-Host "Profile '$name' updated."
    }

    if ($action -eq 'delete') 
    {
        $sshProfiles = $sshProfiles | Where-Object { $_.Name -ne $name }
        Write-Host "Profile '$name' removed."
    }

    $sshProfiles | ConvertTo-Json | Set-Content -Path $configFilePath
}

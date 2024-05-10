# moves all files from subfolders to the main folder in the current directory
function Move-SubfolderFilesToRoot
{
    [CmdletBinding()]
    Param 
    (
        [string]$RootPath = (Get-Location)
    )

    $files = Get-ChildItem -Recurse -File -Path $RootPath

    foreach ($file in $files) 
    {
        Move-Item -Path $file -Destination $RootPath
        Write-Host "Moving file to current directory $file"
        Write-Output $file
    }
}
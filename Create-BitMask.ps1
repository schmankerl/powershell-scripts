#Functions which creates a bitmask by setting the corresponding bit in the mask by using bitwise OR operator and shift left operator
function Create-BitMask {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [int]$BitCount,
        [Parameter(Mandatory = $true)]
        [int[]]$SelectedBits
    )
    
    if ($SelectedBits -eq $null) { throw "SelectedBits cannot be null" }
    
    $mask = 0
    
    foreach ($bit in $SelectedBits) {
        if ($bit -lt 0 -or $bit -ge $BitCount) {
            throw "Invalid bit index: $bit"
        }
        $mask = $mask -bor (1 -shl $bit)
    }
    
    return $mask
}
#Calculates each bit set in a bitmask and outputs it as a decimal value
function Get-SetBits {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [int]$bitmask
    )

    $binary = [Convert]::ToString($bitmask, 2)

    $set_bits = @()
    for ($j = 0; $j -lt $binary.Length; $j++) {
        if ($binary[$j] -eq '1') {
            $bit_position = $binary.Length - $j - 1
            $bit_value = [Math]::Pow(2, $bit_position)
            $set_bits += $bit_value
        }
    }

    return $set_bits
}
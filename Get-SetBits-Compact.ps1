function Get-SetBits {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [int]$bitmask
    )

    [Convert]::ToString($bitmask, 2) -split '' | ForEach-Object {if ($_ -eq '1') {[math]::Pow(2, ($_ -ne '0'))}} | Where-Object {$_ -ne $null}
}

#not working yet
# Get-SetBits 8256
# 2
# 2

# This version of the function converts the bitmask to a binary string, splits it into individual characters, filters out any characters that are not '1', 
# and then applies the formula 2^(position - 1) to each remaining character to calculate its decimal value. The Where-Object cmdlet is used to filter out any null values in the resulting array.

#Calculates each bit set in a bitmask and outputs it as a decimal value
function Get-SetBits {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [int]$bitmask
    )

    # Convert the bitmask to a binary string
    $binary = [Convert]::ToString($bitmask, 2)

    # Loop through the binary string and add the values of all the bits that are set to an array
    $set_bits = @()
    for ($i = 0; $i -lt $binary.Length; $i++) {
        if ($binary[$i] -eq '1') {
            $bit_position = $binary.Length - $i - 1
            $bit_value = [Math]::Pow(2, $bit_position)
            $set_bits += $bit_value
        }
    }

    # Return the array of set bit values
    return $set_bits
}

# In this version of the script, we calculate the decimal value of each set bit using the formula 2^position, 
# where position is the position of the bit from the right (i.e., the least significant bit is at position 0). We then output both the position and the decimal value of each set bit separately.
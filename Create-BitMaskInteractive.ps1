Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Create-BitMaskInteractive {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [int]$BitCount
    )
    
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Select Bits"
    $form.ClientSize = [System.Drawing.Size]::new(800, 150)
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false
    
    $checkboxes = New-Object System.Collections.Generic.List[System.Windows.Forms.CheckBox]
    $rowCount = [Math]::Ceiling($BitCount / 8)
    for ($r = 0; $r -lt $rowCount; $r++) {
        for ($c = 0; $c -lt 8; $c++) {
            $index = $r * 8 + $c
            if ($index -ge $BitCount) {
                break
            }
            $checkbox = New-Object System.Windows.Forms.CheckBox
            #$checkbox.Text = "Bit {0} ({1})" -f $index, [Math]::Pow(2, $index)
            $checkbox.Location = [System.Drawing.Point]::new(10 + $c * 80, 20 + $r * 45)
            $checkbox.Size = [System.Drawing.Size]::new(75, 20)
            $checkbox.Checked = $false
            $checkbox.TextAlign = [System.Drawing.ContentAlignment]::BottomLeft
            $checkboxes.Add($checkbox)
            
            $label = New-Object System.Windows.Forms.Label
            $label.Text = "Bit {0} ({1})" -f $index, [Math]::Pow(2, $index)
            $label.Location = [System.Drawing.Point]::new(10 + $c * 80, 35 + $r * 45)
            $label.Size = [System.Drawing.Size]::new(75, 20)
            $form.Controls.Add($label)
        }
    }
    $form.Controls.AddRange($checkboxes.ToArray())
    
    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = [System.Drawing.Point]::new(10, $rowCount * 45 + 20)
    $okButton.Size = [System.Drawing.Size]::new(75, 23)
    $okButton.Text = "OK"
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $okButton
    $form.Controls.Add($okButton)
    
    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Location = [System.Drawing.Point]::new([System.Math]::Min($BitCount, 8) * 80 - 65, $rowCount * 45 + 20)
    $cancelButton.Size = [System.Drawing.Size]::new(75, 23)
    $cancelButton.Text = "Cancel"
    $cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $cancelButton
    $form.Controls.Add($cancelButton)
    
    $result = $form.ShowDialog()
    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        $selectedBits = @()
        for ($i = 0; $i -lt $BitCount; $i++) {
            if ($checkboxes[$i].Checked) {
                $selectedBits += $i
            }
        }
        return Create-BitMask -BitCount $BitCount -SelectedBits $selectedBits
    } else {
        return $null
    }
}
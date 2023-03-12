Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$Form = New-Object System.Windows.Forms.Form
$Form.Text = "ABC Order Sorter"
$Form.Width = 420
$Form.Height = 250
$Form.StartPosition = "CenterScreen"
$Form.FormBorderStyle = "FixedSingle"

$Label1 = New-Object System.Windows.Forms.Label
$Label1.Text = "Select a text file to sort:"
$Label1.AutoSize = $true
$Label1.Location = New-Object System.Drawing.Point(10, 10)
$Form.Controls.Add($Label1)

$TextBox1 = New-Object System.Windows.Forms.TextBox
$TextBox1.Location = New-Object System.Drawing.Point(10, 40)
$TextBox1.Size = New-Object System.Drawing.Size(300, 20)
$Form.Controls.Add($TextBox1)

$Button1 = New-Object System.Windows.Forms.Button
$Button1.Text = "Browse"
$Button1.Location = New-Object System.Drawing.Point(320, 40)
$Button1.Add_Click({
    $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog
    $FileBrowser.Filter = "Text files (*.txt)|*.txt"
    $Result = $FileBrowser.ShowDialog()
    if ($Result -eq "OK") {
        $TextBox1.Text = $FileBrowser.FileName
    }
})
$Form.Controls.Add($Button1)

$CheckBox1 = New-Object System.Windows.Forms.CheckBox
$CheckBox1.Text = "Remove duplicates"
$CheckBox1.AutoSize = $true
$CheckBox1.Location = New-Object System.Drawing.Point(10, 70)
$Form.Controls.Add($CheckBox1)

$Button2 = New-Object System.Windows.Forms.Button
$Button2.Text = "Sort"
$Button2.Location = New-Object System.Drawing.Point(10, 110)
$Button2.Add_Click({
    $InputFile = $TextBox1.Text
    $OutputFile = "$($InputFile.Split('.')[0])_sorted.txt"

    # Read the input file contents and remove duplicates if the "Remove duplicates" checkbox is checked
    $Content = Get-Content $InputFile
    if ($CheckBox1.Checked) {
        $Content = $Content | Sort-Object -Unique
    } else {
        $Content = $Content | Sort-Object
    }

    Set-Content $OutputFile $Content
    [System.Windows.Forms.MessageBox]::Show("File sorted successfully and saved to $($OutputFile).", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
})
$Form.Controls.Add($Button2)

$Form.ShowDialog()
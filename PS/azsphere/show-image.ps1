
function show-image{
    param (
    [string]$ImageName = '300Homer-Simpson-Doh45.png',
    [string]$Title='Homer',
    [string]$Text = 'Doh!' ,
    $Layout='none',
    $FontStyle='Italic'
)
function clickme
{
    param (
        [System.EventArgs] $e=$null
    )
}
    Add-Type -AssemblyName System.Windows.Forms

    $Form = New-Object system.Windows.Forms.Form
    $Form.Text = $Title
    # $Icon = [system.drawing.icon]::ExtractAssociatedIcon($PSHOME + "\powershell.exe")
    # $Form.Icon = $Icon
    $Image = [system.drawing.image]::FromFile("$global:ScriptDirectory\images\$ImageName")
    $Form.BackgroundImage = $Image
    $Form.BackgroundImageLayout = $Layout
        # None, Tile, Center, Stretch, Zoom
    $Form.Width = $Image.Width+20
    $Form.Height = $Image.Height+40
    $Font = New-Object System.Drawing.Font("Times New Roman",24,[System.Drawing.FontStyle]::$FontStyle)
        # Font styles are: Regular, Bold, Italic, Underline, Strikeout
    $Form.Font = $Font
    $Form.ControlBox=$false
    $Label = New-Object System.Windows.Forms.Label
    $Label.Text = $Text
    $Label.BackColor = [System.Drawing.Color]::FromName("Transparent")
    $Label.AutoSize = $True
    $Form.Controls.Add($Label)


    $Button = New-Object System.Windows.Forms.Button
    $Button.Text = 'Done'
    $Button.Width = 100
    $Button.Height=40
    $Button.Top=12
    $Button.Left=$form.Width-$Button.Width-30
    # https://gallery.technet.microsoft.com/scriptcenter/How-to-build-a-form-in-7e343ba3
    $Button.Add_Click({$Form.Close()}) 
    $form.FormBorderStyle=1
    # System.Windows.Forms.FormBorderStyle.FixedDialog
    $Form.AcceptButton =$Button
    $Form.Controls.Add($Button)
    $Form.ShowDialog()
}
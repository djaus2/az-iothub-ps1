function show-image{
    param (
    [string]$ImageName = '300Homer-Simpson-Doh45.png',
    [string]$Title='Homer',
    [string]$Text = 'Doh!' ,
    $Layout='none',
    $FontStyle='Italic'
)
    Add-Type -AssemblyName System.Windows.Forms
    $Form = New-Object system.Windows.Forms.Form
    $Form.Text = $Title
    $Icon = [system.drawing.icon]::ExtractAssociatedIcon($PSHOME + "\powershell.exe")
    $Form.Icon = $Icon
    $Image = [system.drawing.image]::FromFile("images\$ImageName")
    $Form.BackgroundImage = $Image
    $Form.BackgroundImageLayout = $Layout
        # None, Tile, Center, Stretch, Zoom
    $Form.Width = $Image.Width+20
    $Form.Height = $Image.Height+40
    $Font = New-Object System.Drawing.Font("Times New Roman",24,[System.Drawing.FontStyle]::$FontStyle)
        # Font styles are: Regular, Bold, Italic, Underline, Strikeout
    $Form.Font = $Font
    $Label = New-Object System.Windows.Forms.Label
    $Label.Text = $Text
    $Label.BackColor = "Transparent"
    $Label.AutoSize = $True
    $Form.Controls.Add($Label)
    $Form.ShowDialog()
}

function show-image{
    param (
    [string]$ImageName = '300Homer-Simpson-Doh45.png',
    [string]$Title='Homer',
    [string]$Text = 'Doh!' ,
    $Layout='none',
    $FontStyle='Italic'
) 
        # This function isn't used.
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
    write-host "$global:ScriptDirectory\images\$ImageName"
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

function show-ppt{
    param (
    [string]$ImageNames = '300Homer-Simpson-Doh45.png,dj.jpg,60km.jpg',
    [string]$Title='Homer',
    [string]$Text = '' ,
    $Layout='none',
    $FontStyle='Italic'
)
    $script:imageIndex=0
    $Images = $ImageNames -split ','
    $noImages = $Images.Length
        # This function isn't used.
        function next_click
        {

            
            if ($script:imageIndex -lt ($noImages -1))
            {
                $script:imageIndex++
                $img = $Images[$script:imageIndex]
                $Image = [system.drawing.image]::FromFile("$global:ScriptDirectory\images\$img")
                # $Label.Text = $img
                $Form.BackgroundImage = $Image
                $Form.BackgroundImageLayout = $Layout
                    # None, Tile, Center, Stretch, Zoom
                $Form.Width = $Image.Width+20
                $Form.Height = $Image.Height+40  
                # Nb: Must have more than 1 image
                # Must have moved fwd 
                # So Prev should be Enabled now, regardless              
                if ($script:imageIndex -lt ($noImages -1) ) 
                {
                    $doneButton.Enabled = $false
                    $nextButton.Enabled = $true   
                    $prevButton.Enabled = $true   
                }
                else 
                {
                    $doneButton.Enabled = $true
                    $nextButton.Enabled = $false
                    $prevButton.Enabled = $true
                }
            }
            else{
                $doneButton.Enabled = $true
                $nextButton.Enabled = $false
                $prevButton.Enabled = $true
            }
        }

        function prev_click 
        {

            if ($script:imageIndex -gt 0)
            {
                $script:imageIndex--
                $img = $Images[$script:imageIndex]
                $Image = [system.drawing.image]::FromFile("$global:ScriptDirectory\images\$img")

                $Form.BackgroundImage = $Image
                $Form.BackgroundImageLayout = $Layout
                    # None, Tile, Center, Stretch, Zoom
                $Form.Width = $Image.Width+20
                $Form.Height = $Image.Height+40 
                # Nb: Must have more than 1 image
                # Must have moved back 
                # So Next should be Enabled now, regardless               
                if ($script:imageIndex -gt 0 ) 
                {
                    $doneButton.Enabled = $false
                    $prevButton.Enabled = $true 
                    $nextButton.Enabled = $true      
                }
                else 
                {
                    $doneButton.Enabled = $false
                    $prevButton.Enabled = $false
                    $nextButton.Enabled = $true 
                }
            } else{
                $doneButton.Enabled = $false
                $prevButton.Enabled = $false
                $nextButton.Enabled = $true
            }
        }
    
    
        
    Add-Type -AssemblyName System.Windows.Forms

    $Form = New-Object system.Windows.Forms.Form
    $Form.Text = $Title
    # $Icon = [system.drawing.icon]::ExtractAssociatedIcon($PSHOME + "\powershell.exe")
    # $Form.Icon = $Icon


     $Font = New-Object System.Drawing.Font("Times New Roman",24,[System.Drawing.FontStyle]::$FontStyle)
        # Font styles are: Regular, Bold, Italic, Underline, Strikeout
    $Form.Font = $Font
    $Form.ControlBox=$false
    $Label = New-Object System.Windows.Forms.Label
    $Label.Text = $Text
    $Label.BackColor = [System.Drawing.Color]::FromName("Transparent")
    $Label.AutoSize = $True
    $Form.Controls.Add($Label)

    $nextButton = New-Object System.Windows.Forms.Button
    $nextButton.Text = 'Next'
    $nextButton.Width = 100
    $nextButton.Height=40
    $nextButton.Top=52
    $nextButton.Left=0
    # https://gallery.technet.microsoft.com/scriptcenter/How-to-build-a-form-in-7e343ba3
    $nextButton.Add_click({
        next_click 
    })

    $prevButton = New-Object System.Windows.Forms.Button
    $prevButton.Text = 'Prev'
    $prevButton.Width = 100
    $prevButton.Height=40
    $prevButton.Top=92
    $prevButton.Left=0
    # https://gallery.technet.microsoft.com/scriptcenter/How-to-build-a-form-in-7e343ba3
    # $prevButton.Add_Click({$prev_click})
    $prevButton.Add_click({
        prev_click
    })
    

    $doneButton = New-Object System.Windows.Forms.Button
    $doneButton.Text = 'Done'
    $doneButton.Width = 100
    $doneButton.Height=40
    $doneButton.Top=12
    $doneButton.Left=0
    # https://gallery.technet.microsoft.com/scriptcenter/How-to-build-a-form-in-7e343ba3
    $doneButton.Add_Click({$Form.Close()}) 
    



    $form.FormBorderStyle=1
    # System.Windows.Forms.FormBorderStyle.FixedDialog
    $Form.AcceptButton =$doneButton
    $Form.Controls.Add($doneButton)
    $Form.Controls.Add($nextButton)
    $Form.Controls.Add($prevButton)

    if ($noImages -gt 0)
    {
        $script:imageIndex=0
        $img = $Images[$script:imageIndex]
        $Image = [system.drawing.image]::FromFile("$global:ScriptDirectory\images\$img")
        $Form.BackgroundImage = $Image
        $Form.BackgroundImageLayout = $Layout
            # None, Tile, Center, Stretch, Zoom
        $Form.Width = $Image.Width+20
        $Form.Height = $Image.Height+40  

        $doneButton.Enabled = $fasle
        $nextButton.Enabled = $true
        $prevButton.Enabled = $false 
        $doneButton.Visible = $true
        $nextButton.Visible = $true
        $prevButton.Visible = $true
    }
    else 
    {
        $script:imageIndex=-1
        $Form.Width = 300
        $Form.Height = 200 
        $doneButton.Enabled = $true
        $nextButton.Enabled = $false
        $prevButton.Enabled = $false
        $nextButton.Visible = $false
        $prevButton.Visible = $false

    }

    $Form.ShowDialog()
}
# show-image 'iot-central-new-3-V2.png' 'Open Verify' 
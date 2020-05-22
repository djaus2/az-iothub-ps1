
function show-form{

    Add-Type -AssemblyName System.Windows.Forms

    $Form = New-Object system.Windows.Forms.Form
    $Form.Text = "az-iothub-ps"
    $form.Name ="az-iothub-ps"
    $form.Width = 564
    $form.Height= 489
    $form.left= 200
    $form.Top = 100

    $Form.ControlBox=$false
    $form.FormBorderStyle=1
    $form.SuspendLayout()



    $label1 = New-Object  System.Windows.Forms.Label
    $linkLabel1 = New-Object  System.Windows.Forms.LinkLabel
    $lblSubscription = New-Object  System.Windows.Forms.LinkLabel

    $linkLabel2 = New-Object  System.Windows.Forms.LinkLabel
    $linkLabel3 = New-Object  System.Windows.Forms.LinkLabel
    $linkLabel4 = New-Object  System.Windows.Forms.LinkLabel
    $linkLabel5 = New-Object  System.Windows.Forms.LinkLabel
    $linkLabel6 = New-Object  System.Windows.Forms.LinkLabel
    
    $txtGroup = New-Object  System.Windows.Forms.TextBox
    
    $txtHub = New-Object  System.Windows.Forms.TextBox
    $txtDevice = New-Object  System.Windows.Forms.TextBox
    $txtDPS = New-Object  System.Windows.Forms.TextBox
    # $chkDevice = New-Object  System.Windows.Forms.CheckBox
    # $chkDPS = New-Object  System.Windows.Forms.CheckBox

    # $btnCancel = New-Object  System.Windows.Forms.Button
    # $btnClear = New-Object  System.Windows.Forms.Button
    # $btnGenerate = New-Object  System.Windows.Forms.Button
    # $btnOpen = New-Object  System.Windows.Forms.Button

    $txtHubLocation = New-Object  System.Windows.Forms.TextBox

    # $txtHubSKU = New-Object  System.Windows.Forms.TextBox
    $linkLabel7 = New-Object  System.Windows.Forms.LinkLabel
    # $checkBox1 = New-Object  System.Windows.Forms.CheckBox

    $tbLeft = 220
    $tbSize = New-object System.Drawing.Size(240, 24)
    
    $FontHeading = New-Object System.Drawing.Font("Times New Roman",36,[System.Drawing.FontStyle]::Bold)
    $FontReg = New-Object System.Drawing.Font("Times New Roman",18,[System.Drawing.FontStyle]::Regular)
    $FontRegSmaller = New-Object System.Drawing.Font("Times New Roman",14,[System.Drawing.FontStyle]::Regular)
    $FontItalic = New-Object System.Drawing.Font("Times New Roman",18,[System.Drawing.FontStyle]::Italic)
    $Fontbold = New-Object System.Drawing.Font("Times New Roman",18,[System.Drawing.FontStyle]::Bold)
    $FontUnder = New-Object System.Drawing.Font("Times New Roman",18,[System.Drawing.FontStyle]::Underline)
    $FontStrike = New-Object System.Drawing.Font("Times New Roman",18,[System.Drawing.FontStyle]::Strikeout)
    # Font styles are: Regular, Bold, Italic, Underline, Strikeout

    $listBox = New-Object System.Windows.Forms.Listbox
    # $listBox.Location = New-Object System.Drawing.Point(10,40)
    # $listBox.Size = New-Object System.Drawing.Size(260,20)
    $listBox.Location = new-object  System.Drawing.Point(218, 328)
    $listBox.Size = new-object System.Drawing.Size(36, 95)
    
    $listBox.SelectionMode = 'One'

    $skus = 'B1,B2,B3,F1,S1,S2,S3'
    $lines =$skus  -split ','

    foreach ($line in $lines) 
    {
        [void] $listBox.Items.Add($line)
    }

    $listBox.Font =  $FontRegSmaller
    $ListBox.SelectedItem = 'S1'
    
    $listBox.Height = 100
    $listBox.Width  = 60
    $form.Controls.Add($listBox)


    <# Only S1 is available 
    $DevSKUListBox= New-Object System.Windows.Forms.Listbox
    # $DevSKUListBox.Location = New-Object System.Drawing.Point(10,40)
    # $DevSKUListBox.Size = New-Object System.Drawing.Size(260,20)
    $DevSKUListBox.Location = new-object  System.Drawing.Point(400, 328)
    $DevSKUListBox.Size = new-object System.Drawing.Size(36, 95)
    
    $DevSKUListBox.SelectionMode = 'One'

    $skusDPS = 'B1,B2,B3,F1,S1,S2,S3'
    $linesDPS =$skusDPS  -split ','

    foreach ($lineDPS in $linesDPS) 
    {
        [void] $DevSKUListBox.Items.Add($lineDPS)
    }

    $DevSKUListBox.Font =  $FontRegSmaller
    $DevSKUListBox.SelectedItem = 'S1'
    
    $DevSKUListBox.Height = 100
    $DevSKUListBox.Width  = 60
    $form.Controls.Add($DevSKUListBox)
    #>


    $label1.Font = $FontHeading
    $label1.ForeColor = [System.Drawing.Color]::FromName("Red")
    $Label1.AutoSize = $true
    $label1.Top= 40
    $label1.Left = 120
    $label1.Text = "az-iothub-ps"

    $linklabel1.Font = $FontItalic
    $linklabel1.ForeColor = [System.Drawing.Color]::FromName("Blue")
    $linklabel1.AutoSize = $true
    $linklabel1.Top= 94
    $linklabel1.Left = 74
    $linklabel1.Text = "Subscription:"

    $lblSubscription.Font = $FontItalic
    $lblSubscription.ForeColor = [System.Drawing.Color]::FromName("Black")
    $lblSubscription.AutoSize = $true
    $lblSubscription.Top= 94
    $lblSubscription.Left = $tbLeft
    $lblSubscription.Text = "$global:Subscription"

    $linklabel2.Font = $FontItalic
    $linklabel2.ForeColor = [System.Drawing.Color]::FromName("Blue")
    $linklabel2.AutoSize = $true

    $linklabel2.Left = 130
    $linklabel2.Top= 128

    $linklabel2.Text = "Group:"

    $linklabel3.Font = $FontItalic
    $linklabel3.ForeColor = [System.Drawing.Color]::FromName("Blue")
    $linklabel3.AutoSize = $true

    $linklabel3.Left = 112
    $linklabel3.Top= 166

    $linklabel3.Text = "IoT Hub:"

    $linkLabel4.Font = $FontItalic
    $linklabel4.ForeColor = [System.Drawing.Color]::FromName("Blue")
    $linklabel4.AutoSize = $true

    $linklabel4.Left = 121
    $linklabel4.Top= 202

    $linklabel4.Text = "Device:"

    
    $linklabel5.Font = $FontItalic
    $linklabel5.ForeColor = [System.Drawing.Color]::FromName("Blue")
    $linklabel5.AutoSize = $true

    $linklabel5.Left =142
    $linkLabel5.Top= 238

    $linklabel5.Text = "DPS:"

    $linklabel6.Font = $FontItalic
    $linklabel6.ForeColor = [System.Drawing.Color]::FromName("Blue")
    $linklabel6.AutoSize = $true

    $linklabel6.Left = 64
    $linkLabel6.Top= 290

    $linklabel6.Text = "Hub Location:"

    $linklabel7.Font = $FontItalic
    $linklabel7.ForeColor = [System.Drawing.Color]::FromName("Blue")
    $linklabel7.AutoSize = $true

    $linklabel7.Left = 100
    $linkLabel7.Top= 326
    $linklabel7.Text = "Hub SKU:"

    $OKLabel = New-Object  System.Windows.Forms.LinkLabel
    $OKLabel.Location = new-object System.Drawing.Point(230, 0)
    $OKLabel.Font = $FontItalic
    $OKLabel.ForeColor = [System.Drawing.Color]::FromName("Black")
    $OKLabel.AutoSize = $true
    $OKLabel.Text = ""


    #########################

    $txtGroup.Font = $FontReg
    $txtGroup.Location = New-Object System.Drawing.Point($tbLeft,  $linklabel2.Top)
    $txtGroup.Size = $tbSize
    $txtGroup.Text = "$global:groupname"
    # $txtGroup.PlaceholderText = "Enter new group name"

    $txtHub.Font = $FontReg
    $txtHub.Location = New-Object System.Drawing.Point($tbLeft, $linklabel3.Top)
    $txtHub.Size = $tbSize
    $txtHub.Text = $global:hubname

    $txtDevice.Font = $FontReg
    $txtDevice.Location = New-Object System.Drawing.Point($tbLeft, $linklabel4.Top)
    $txtDevice.Size = $tbSize
    $txtDevice.Text = $global:devicename

    $txtDPS.Font = $FontReg
    $txtDPS.Location = New-Object System.Drawing.Point($tbLeft, $linklabel5.Top)
    $txtDPS.Size = $tbSize
    $txtDPS.Text = $global:dpsName

    $txtHubLocation.Font = $FontReg
    $txtHubLocation.Location = New-Object System.Drawing.Point($tbLeft, $linklabel6.Top)
    $txtHubLocation.Size = $tbSize
    $txtHubLocation.Text = "This is handled later."

    <# $txtHubSKU.Font = $FontReg
    $txtHubSKU.Location = New-Object System.Drawing.Point($tbLeft, $linklabel7.Top)
    $txtHubSKU.Size = $tbSize
    $txtHubSKU.Text = ""#>

    ################# Buttons ######################################
    <#
    $btnSize = new-object System.Drawing.Size(69, 27)
    $btnSize2 = new-object System.Drawing.Size(180, 50)

    $btnCancel.Location = new-object System.Drawing.Point(430, 12)
    $btnCancel.Size = $btnSize
    $btnCancel.Text = "Cancel"
    $btnCancel.Add_Click({
        $global:retVal='Cancel'
        $form.Close()
    }) 

    $btnClear.Location = new-object System.Drawing.Point(430,42)
    $btnClear.Size = $btnSize
    $btnClear.Text = "Clear All"

    $btnClear.Add_Click( 
    { 
        $txtGroup.Text =""
        # $txtHub.Text =""
        $txtDevice.Text =""
        $txtDPS.Text =""
        $txtHubLocation.Text =""
        $txtSKU.Text =""
        $txtHubLocation.Text = "This is handled later."
    })

    $btnOpen.Location = new-object System.Drawing.Point(20,380)
    $btnOpen.Size = $btnSize2
    $btnOpen.Text = "Go to az-iothub-PS."

    $btnOpen.Add_Click( 
    { 
        $global:retVal=''
        $form.Close()
    })

    $btnGenerate.Location = new-object System.Drawing.Point(350,380)
    $btnGenerate.Size = $btnSize2
    $btnGenerate.Text = "Generate Entities as named"
    $btnGenerate.Add_Click( 
    {
        $global:retVal= $txtGroup.Text
        $global:retVal += ',' + $TxtHub.Text
        $global:retVal += ',' + $TxtDevice.Text
        $strn = $TextDPS.Text
        if (-not ( [string]::IsNullOrEmpty($strn)))
        {
            $global:retVal += ',' + $strn
        }
        $global:delay = "5"
        $global:SKU = $listBox.SelectedItem
        $form.Close()

    })
    #>
    ################ Menus ################
    $menuStrip1 = new-object System.Windows.Forms.MenuStrip
    $menuStrip1.SuspendLayout()

    $menuStrip1.Location = new-object System.Drawing.Point(0, 0)
    $menuStrip1.Size = new-object System.Drawing.Size(1000, 24)
    $menuStrip1.Text = "az-iothub-ps Menu"
    $menuStrip1.Font = $FontReg

    $actionsToolStripMenuItem = new-object System.Windows.Forms.ToolStripMenuItem
    $azloginToolStripMenuItem = new-object System.Windows.Forms.ToolStripMenuItem
    $goDirectToAziothubpsToolStripMenuItem = new-object System.Windows.Forms.ToolStripMenuItem
    $generateEntitiesToolStripMenuItem = new-object System.Windows.Forms.ToolStripMenuItem
    $cancelToolStripMenuItem = new-object System.Windows.Forms.ToolStripMenuItem

    $azloginToolStripMenuItem.Size = new-object System.Drawing.Size(208, 22)
    $azloginToolStripMenuItem.Text = "&Azure Cli Login"
    $azloginToolStripMenuItem.Font = $FontRegSmall
    $azloginToolStripMenuItem.ForeColor = [System.Drawing.Color]::FromName("Brown")
    $azloginToolStripMenuItem.Add_Click( 
    { 
        $lblSubscription.Text ="Pending"
        az login
        $acc =az account show -o json | out-string | ConvertFrom-Json
        $global:Subscription =  $acc.name 
        $lblSubscription.Text  = $global:Subscription
        [Console]::ResetColor()
        $global:skipLoginCheck="true"
    })

    $goDirectToAziothubpsToolStripMenuItem.Size = new-object System.Drawing.Size(208, 22)
    $goDirectToAziothubpsToolStripMenuItem.Text = "&Go Direct to az-iothub-p"
    $goDirectToAziothubpsToolStripMenuItem.Font = $FontRegSmall
    $goDirectToAziothubpsToolStripMenuItem.ForeColor = [System.Drawing.Color]::FromName("Brown")
    $goDirectToAziothubpsToolStripMenuItem.Add_Click( 
    { 
        $global:retVal=''
        $form.Close()
    })

    $generateEntitiesToolStripMenuItem.Size = new-object System.Drawing.Size(208, 22)
    $generateEntitiesToolStripMenuItem.Text = "Generate &Entities"
    $generateEntitiesToolStripMenuItem.Font = $FontRegSmall
    $generateEntitiesToolStripMenuItem.ForeColor = [System.Drawing.Color]::FromName("Brown")
    $generateEntitiesToolStripMenuItem.Add_Click( 
    { 
        $global:retVal= $txtGroup.Text
        $global:retVal += ',' + $TxtHub.Text
        $global:retVal += ',' + $TxtDevice.Text
        $strn = $TextDPS.Text
        if (-not ( [string]::IsNullOrEmpty($strn)))
        {
            $global:retVal += ',' + $strn
        }
        $global:delay = "5"
        $global:SKU = $listBox.SelectedItem
        $form.Close()
    })

    $cancelToolStripMenuItem.Size = new-object System.Drawing.Size(208, 22)
    $cancelToolStripMenuItem.Text = "&Cancel"
    $cancelToolStripMenuItem.Font = $FontRegSmall
    $cancelToolStripMenuItem.ForeColor = [System.Drawing.Color]::FromName("Red")
    $cancelToolStripMenuItem.Add_Click( 
    { 
        $global:retVal='Cancel'
        $form.Close()
    })

    $actionsToolStripMenuItem.Size = new-object System.Drawing.Size(300, 20)
    $actionsToolStripMenuItem.Text =  '&Actions'
    [System.Windows.Forms.ToolStripItem[]]$items = $azloginToolStripMenuItem, $goDirectToAziothubpsToolStripMenuItem, $generateEntitiesToolStripMenuItem,$cancelToolStripMenuItem 
    $actionsToolStripMenuItem.DropDownItems.AddRange($items)
    $actionsToolStripMenuItem.Font = $FontRegSmall
    $actionsToolStripMenuItem.ForeColor = [System.Drawing.Color]::FromName("Purple")

    $clearToolStripMenuItem = new-object System.Windows.Forms.ToolStripMenuItem
    $clearToolStripMenuItem.Size = new-object System.Drawing.Size(208, 22)
    $clearToolStripMenuItem.Text = "&Clear"
    $clearToolStripMenuItem.Font = $FontRegSmall
    $clearToolStripMenuItem.ForeColor = [System.Drawing.Color]::FromName("Red")
    $clearToolStripMenuItem.Add_Click( 
    { 
        $txtGroup.Text =""
        $txtHub.Text =""
        $txtDevice.Text =""
        $txtDPS.Text =""
        $listBox.SelectedItem ="S1"
        $txtHubLocation.Text = "This is handled later."
        $OKLabel.Text = ""
    })

    $reloadCurrentToolStripMenuItem = new-object System.Windows.Forms.ToolStripMenuItem
    $reloadCurrentToolStripMenuItem.Size = new-object System.Drawing.Size(208, 22)
    $reloadCurrentToolStripMenuItem.Text = "&Reload Current Entities"
    $reloadCurrentToolStripMenuItem.Font = $FontRegSmall
    $reloadCurrentToolStripMenuItem.ForeColor = [System.Drawing.Color]::FromName("Brown")
    $reloadCurrentToolStripMenuItem.Add_Click( 
    { 
        $txtGroup.Text = "$global:groupname"
        $txtHub.Text = $global:hubname
        $txtDevice.Text = $global:devicename
        $txtDPS.Text = $global:dpsName
        $listBox.SelectedItem ="S1"
        $txtHubLocation.Text = "This is handled later."
        $OKLabel.Text = ""
    })

    $checlAvailabilityCurrentToolStripMenuItem = new-object System.Windows.Forms.ToolStripMenuItem
    $checlAvailabilityCurrentToolStripMenuItem.Size = new-object System.Drawing.Size(208, 22)
    $checlAvailabilityCurrentToolStripMenuItem.Text = "Check &Availability of Entity Names"
    $checlAvailabilityCurrentToolStripMenuItem.Font = $FontRegSmall
    $checlAvailabilityCurrentToolStripMenuItem.ForeColor = [System.Drawing.Color]::FromName("Brown")
    $checlAvailabilityCurrentToolStripMenuItem.Add_Click( 
    { 
        If (-not([string]::IsNullOrEmpty($txtGroup.Text ))){
            if (-not (Check-Group $global:Subscription $txtGroup.Text $true))
            {
                If (-not([string]::IsNullOrEmpty($txtHub.Text )))
                {
                    [bool]$res =Check-Hub $global:Subscription $txtHub.Text $true
                    $res= $global:retVal
                    $global:retVal = $null
                    if (-not $res) {
                        # Device and DPS are tied to Hub so if it doesn't exist, OK
                        If (-not([string]::IsNullOrEmpty($txtDevice.Text ))){
                            If (-not([string]::IsNullOrEmpty($txtDPS.Text ))){  
                            }
                        }
                        $OKLabel.Text = "Enity Names are available"
                    }
                    else{
                        $OKLabel.Text = "Hub Name not available"
                        $txtHub.Text =""
                        $txtDevice.Text =""
                        $txtDPS.Text =""
                    }
                }
            }
            else{
                $OKLabel.Text = "Group Name not available"
                $txtGroup.Text =""
                $txtHub.Text =""
                $txtDevice.Text =""
                $txtDPS.Text =""
            }
        }
        [Console]::ResetColor()
    })







    $editToolStripMenuItem = new-object System.Windows.Forms.ToolStripMenuItem
    $editToolStripMenuItem.Size = new-object System.Drawing.Size(300, 20)
    $editToolStripMenuItem.Text =  '&Edit'
    [System.Windows.Forms.ToolStripItem[]]$items =  $clearToolStripMenuItem,$reloadCurrentToolStripMenuItem,$checlAvailabilityCurrentToolStripMenuItem
    $editToolStripMenuItem.DropDownItems.AddRange($items)
    $editToolStripMenuItem.Font = $FontRegSmall
    $editToolStripMenuItem.ForeColor = [System.Drawing.Color]::FromName("Purple")
    
    
    [System.Windows.Forms.ToolStripItem[]] $items0 = $actionsToolStripMenuItem,$editToolStripMenuItem
    $menuStrip1.Items.AddRange($items0)
    #######################################


  
    # $form.Controls.Add($checkBox1)
    # $form.Controls.Add($txtHubSKU)
    $form.Controls.Add($linkLabel7)
    $form.Controls.Add($txtHubLocation)
    # $form.Controls.Add($btnCancel)
    # $form.Controls.Add($btnClear)
    # $form.Controls.Add($btnOpen)
    # $form.Controls.Add($btnGenerate)
    # $form.Controls.Add($chkDPS)
    # $form.Controls.Add($chkDevice)
    $form.Controls.Add($OKLabel)
    $form.Controls.Add($txtDPS)
    $form.Controls.Add($txtDevice)
    $form.Controls.Add($txtHub)
    $form.Controls.Add($txtGroup)
    $form.Controls.Add($linkLabel6)
    $form.Controls.Add($linkLabel5)
    $form.Controls.Add($linkLabel4)
    $form.Controls.Add($linkLabel3)
    $form.Controls.Add($linkLabel2)
    $form.Controls.Add($lblSubscription)
    $form.Controls.Add($linkLabel1)
    $form.Controls.Add($label1)

    $form.Controls.Add($menuStrip1)
    $form.MainMenuStrip = $menuStrip1

    $menuStrip1.ResumeLayout($false)
    $menuStrip1.PerformLayout()
    $form.ResumeLayout($false)
    $form.PerformLayout()

    $form.ShowDialog()
}

# show-form
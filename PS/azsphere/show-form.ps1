
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
    $chkDevice = New-Object  System.Windows.Forms.CheckBox
    $chkDPS = New-Object  System.Windows.Forms.CheckBox

    $btnCancel = New-Object  System.Windows.Forms.Button
    $btnClear = New-Object  System.Windows.Forms.Button
    $btnGenerate = New-Object  System.Windows.Forms.Button
    $btnOpen = New-Object  System.Windows.Forms.Button

    $txtHubLocation = New-Object  System.Windows.Forms.TextBox

    # $txtHubSKU = New-Object  System.Windows.Forms.TextBox
    $linkLabel7 = New-Object  System.Windows.Forms.LinkLabel
    $checkBox1 = New-Object  System.Windows.Forms.CheckBox




<#
    $items = @("B1","B2","F","S1")
    <#temz = new-object object[] {
        "B1",
        "B2",
        "B3",
        "F",
        "S1",
        "S2",
        "S3"}
    $itemz =[object[]] $items.Invoke
    read-host "2"
    $listBox.Items.Add("F")
    read-host "3"

    # $listBox.Items.AddRange($itemz)

    $listBox = New-Object System.Windows.Forms.Listbox
    $listBox.Location = new-object  System.Drawing.Point(240, 331)
    $listBox.Size = new-object System.Drawing.Size(36, 95)

    [void] $listBox.Items.Add('B1')
    [void] $listBox.Items.Add('B2')
    [void] $listBox.Items.Add('F')
    [void] $listBox.Items.Add('S1')
    [void] $listBox.Items.Add('S2')

    read-host $listBox.Items[0]

    $form1.Controls.Add($listBox)#>



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
    $listBox.Location = new-object  System.Drawing.Point(232, 331)
    $listBox.Size = new-object System.Drawing.Size(36, 95)
    
    $listBox.SelectionMode = 'MultiExtended'
   
    <#
    [void] $listBox.Items.Add('B1')
    [void] $listBox.Items.Add('B2')
    [void] $listBox.Items.Add('F')
    [void] $listBox.Items.Add('S1')
    [void] $listBox.Items.Add('S2')
    #>

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

    $label1.Font = $FontHeading
    $label1.ForeColor = [System.Drawing.Color]::FromName("Red")
    $Label1.AutoSize = $true
    $label1.Top= 10
    $label1.Left = 10
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
    $txtHubLocation.Text = "This is ignored: 2Do"

    <# $txtHubSKU.Font = $FontReg
    $txtHubSKU.Location = New-Object System.Drawing.Point($tbLeft, $linklabel7.Top)
    $txtHubSKU.Size = $tbSize
    $txtHubSKU.Text = ""#>


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
        $txtHubLocation.Text = "This is ignored. 2Do"
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


  
    $form.Controls.Add($checkBox1)
    # $form.Controls.Add($txtHubSKU)
    $form.Controls.Add($linkLabel7)
    $form.Controls.Add($txtHubLocation)
    $form.Controls.Add($linkLabel2)


    $form.Controls.Add($btnCancel)
    $form.Controls.Add($btnClear)
    $form.Controls.Add($btnOpen)
    $form.Controls.Add($btnGenerate)
    $form.Controls.Add($chkDPS)
    $form.Controls.Add($chkDevice)
    $form.Controls.Add($txtDPS)
    $form.Controls.Add($txtDevice)
    $form.Controls.Add($txtHub)
    $form.Controls.Add($txtGroup)
    $form.Controls.Add($linkLabel6)
    $form.Controls.Add($linkLabel5)
    $form.Controls.Add($linkLabel4)
    $form.Controls.Add($linkLabel3)
    $form.Controls.Add($lblSubscription)
    $form.Controls.Add($linkLabel1)
    $form.Controls.Add($label1)

    $form.ShowDialog()
}

# show-form
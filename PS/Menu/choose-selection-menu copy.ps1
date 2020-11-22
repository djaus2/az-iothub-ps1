function choose-selection-cpy{
param (
    [Parameter(Mandatory)]
     [string]$ListString, 
     [string]$Title,
     [string]$CurrentSelection='None',
     [string]$Sep=',',
     [string]$AdditionalMenuOptions='B. Back',
     [int]$ItemsPerLine=1,
     $ColWidth=1
 )
    # Can't pass empty string as a parameter
    if ($ListString -eq ' ')
    {
        $ListString =''
    }

    If (-not ([string]::IsNullOrEmpty($env:IsRedirected)))
    {
        return choose-selection-redirected $ListString $Title $CurrentSelection $Sep $AdditionalMenuOptions $ItemsPerLine $ColWidth
    }
    else
    {
        $Default = -1
        $SelectionList1 =@()
        # Ref: https://www.jonathanmedd.net/2014/01/adding-and-removing-items-from-a-powershell-array.html
        $SelectionList = {$SelectionList1}.Invoke()
        [string]$temp =  [string]$ColWidth
        $FormatStrn = '{0,-' + $temp + '}'
        
        $DefaultNo = -2
        
        # These two checks not required as both parameters are mandatory
        if ([string]::IsNullOrEmpty($ListString))
        {

        }
        elseif  (($ListString.ToUpper() -eq '--HELP') -or ($ListString.ToUpper() -eq '-H'))
        {
            $prompt = 'Usage: menu ListString Title [DisplayIndex] [CodeIndex] [ItemsPerLine] [ColWidth] [Current Selection]'
            write-Host $prompt
            write-Host ''
            $prompt = 'ListString:       Required. A string of lines (new line separated). Each line is an entitiy to be listed in the menu.'
            write-Host $prompt
            $prompt = '                  Each line is a .tsv list of entity properties'
            write-Host $prompt
            $prompt = 'Title:            Required. The entity name'
            write-Host $prompt
            $prompt = 'DisplayIndex:     Optional. Zero based index to entity property to display. (Default 0)'
            write-Host $prompt
            $prompt = 'CodeIndex:        Optional. Zero based index to entity property to to be returned. (Default 0)'
            write-Host $prompt    
            $prompt = 'ItemsPerLine:     Optional. Number of items to be displayed per line. (Default 1)'
            write-Host $prompt   
            $prompt = 'ColWidth:         Optional. Space for each item name. (Default 22)'
            write-Host $prompt   
            $prompt = 'CurrentSelection: Optional. Current selection as property displayed. (Default blank) Exiting'
            write-Host $prompt 
            write-Host ''   
        
            return ''
        }  
        if ([string]::IsNullOrEmpty($Title))
        {
            $prompt = 'No Title for menu supplied. Run menu --help for usage.'
            write-Host $prompt
            return  'Back'
        }  
        
        if(-not([string]::IsNullOrEmpty($ListString)))
        {
            $lines =$ListString  -split $Sep[0]

            $noEntities = $lines.Length

            [int] $i=1

            write-Host ''
            $prompt = 'Select the ' + $Title
            write-Host $prompt
            write-Host ''
            $col=0
            foreach ($line in $lines) 
            {
                if ([string]::IsNullOrEmpty($line))
                {   
                    write-Host ''
                    $i++        
                    break
                }
                else {       
                    $itemToList = $line
                    # Ref: https://stackoverflow.com/questions/25322636/powershell-convert-string-to-number
                    $SelectionList.Add($i)    > $null    
                }
                [string]$prompt = [string]$i
                $prompt += '. '     
                $prompt +=  $itemToList
                $prompt = [string]::Format($FormatStrn,$prompt )
                if ($CurrentSelection -eq 'None')
                {
                    write-Host $prompt -NoNewline
                
            
                    if ($col -eq ($ItemsPerLine-1))
                    {
                        $col =0
                        write-Host ''
                    }
                    else 
                    {
                        $Tab = [char]9
                        write-Host $Tab -NoNewline
                        $col++
                    }
                }
                elseif ( $itemToList -eq $CurrentSelection)
                {
                    $DefaultNo = $i
            
                    write-Host ''
                    [string]$prompt = [string]$i
                    $prompt += '. '   
                    write-Host $prompt -NoNewline
                    $prompt = [string]::Format($FormatStrn,$itemToList )
                    write-Host $itemToList  -ForegroundColor Yellow -NoNewline
                    write-Host ' <-- Default Selection' -ForegroundColor DarkGreen 
                    $col = 0
                }
                else 
                {
                    
                    write-Host $prompt -NoNewline
                
            
                    if ($col -eq ($ItemsPerLine-1))
                    {
                        $col =0
                        write-Host ''
                    }
                    else 
                    {
                        $Tab = [char]9
                        write-Host $Tab -NoNewline
                        $col++
                    }
                }
                
                $i++
            }
        }

        If (-not ([string]::IsNullOrEmpty($AdditionalMenuOptions)))
        {
            $Options = $AdditionalMenuOptions -split ','
            write-Host ''
            foreach ($option in $Options)
            {
                
                write-Host $option
                $val = [byte][char]$option[0]
                if ($val -ne -100)
                {
                    $n = $SelectionList.Add($val)
                }
            }
        }
        
        # [int]$selection =1
        #$SelectionList | where-object {$_ } | Foreach-Object { write-Host '>>' -NoNewline;write-Host $_ 
        #}
        $prompt ="Please make a (numerical) selection .. Or [Enter] if previous selection highlighted."
        # $SelectionList =@('1','2','3','4','-1','-2','-3')
        write-Host $prompt
        $first = $true
        
        do 
        {
            # Ref: https://stackoverflow.com/questions/31603128/check-if-a-string-contains-any-substring-in-an-array-in-powershell
            # Ref https://stackoverflow.com/questions/25768509/read-individual-key-presses-in-powershell
            $KeyPress = [System.Console]::ReadKey($true)
            $K = $KeyPress.Key
            $KK = $KeyPress.KeyChar
        
            $val=-10
            switch ( $k )
            {
                # Numerical Keys 0 to 9
                'D1'  {$val = 0  }
                'D1'  {$val = 1  }
                'D2'  {$val = 2  }
                'D3'  {$val = 3  }
                'D4'  {$val = 4  }
                'D5'  {$val = 5  }
                'D6'  {$val = 6  }
                'D7'  {$val = 7  }
                'D8'  {$val = 8  }
                'D9'  {$val = 9  }
                'D0'  {$val = 10  }
                UpArrow  { 
                    switch ($Default )
                    {
                        1 { $Default = 1}
                        2 { $Default = 1}
                        3 { $Default = 2}
                        4 { $Default = 3}
                    } 
                }
                DownArrow  { 
                    switch ($Default )
                    {
                        1 { $Default = 2}
                        2 { $Default= 3}
                        3 { $Default= 4}
                        4 { $Default= 5}
                    } 
                }
                Enter { 
                    If (-not ([string]::IsNullOrEmpty($CurrentSelection)))
                    {
                        $val = $DefaultNo
                    } 
                    else{
                        $val = -11
                    }
                }
                Default {
                    $val = [byte][char]$kk
                }
        
            }
            if ( $SelectionList -notcontains $val){
                if ($first){
                    write-Host '  --Invalid' -NoNewLine
                    $first = $false
                }
            }
            ## $resp = [string]$val
        # Ref: https://www.computerperformance.co.uk/powershell/contains/
        } while ( $SelectionList -notcontains $val) ##  $resp)
        
        
        if ($first -eq $false)
        {
            write-Host `b`b`b`b`b`b`b -NoNewLine
            write-Host 'OK Now  ' 
        }
        
        $output = ''
        $selection = $val
        if ($selection -gt 19)
        {
            $optionstrn = $options[$selection-20]
            $opt = $optionstrn -split ' '
            $global:retVal = $opt[1]
            return  $global:retVal
        }
        else 
        {          
            $output  =($ListString-split ',')[$selection-1]  
        }
        write-Host ''
        $promptFinal = $Title +' "' +  $output + '" selected'
        write-Host $promptFinal

        $val=$null
        $SelectionList = $null
        $ListString = $null
        
        $global:retVal =  $output
        $global:retVal1 = $k
        $global:retVal2 = $kk

        return $output
    }
}
 
 

# SIG # Begin signature block
# MIIFvQYJKoZIhvcNAQcCoIIFrjCCBaoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU73qEvu4DjPeHiHRgfIw28dF/
# z2GgggNLMIIDRzCCAi+gAwIBAgIQa6QCRzY4lrZG+RhikcTxrjANBgkqhkiG9w0B
# AQsFADAnMSUwIwYDVQQDDBxkYXZpZGpvbmVzQHNwb3J0cm9uaWNzLmNvLmF1MB4X
# DTIwMTExOTA3MTY1OVoXDTIxMTExOTA3MzY1OVowJzElMCMGA1UEAwwcZGF2aWRq
# b25lc0BzcG9ydHJvbmljcy5jby5hdTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
# AQoCggEBALuIy+cU+dHYEoYaO2h4ZzyBz344XEcL1jupJJsY/CE1XgqSEVTpFShx
# DYOQbsuSh88Wto/7IYtVY+vqX4rn36pc1rYOLo3EK8kNIhkb3x21R078VnlWWg0D
# Ok3xmuON/iK6FawNjJ7y7fppSqVNTEo2j8I5h51Pssn1PxS86aERWgElnN7jWB+B
# wvwh4zULooQNf+a8/Yd0FlWo1ggM7+hmvUURYa6ueRy+G/LyWwhtWLy9BpitTWRP
# wqjjHlc0/z1qrNc0M139tbszE/v57WCIbZahrZWdbSQvEBXSfqCtCbkLMgEVZ4QX
# MQx017dkfoEKtwxc9AFgZ7IA3Mo4FwkCAwEAAaNvMG0wDgYDVR0PAQH/BAQDAgeA
# MBMGA1UdJQQMMAoGCCsGAQUFBwMDMCcGA1UdEQQgMB6CHGRhdmlkam9uZXNAc3Bv
# cnRyb25pY3MuY28uYXUwHQYDVR0OBBYEFG90a5e0b1NlWeK8Yq9ooDdhrv4aMA0G
# CSqGSIb3DQEBCwUAA4IBAQBenA40fJVqvPdp2R+rTSRaB2iOENA+p99qsYsHp4Gl
# hU49AHneB5Et9lEWd6UBZ+reYcNbitaD/A+4kPOArm6MVxmYL0oc9QKvc2T9z6YY
# O47PKk4NkU3vH2SwygPHD8MlNgpJMO89/u7Sb08Xa5dALGo7VMcPiTNnMji45RMM
# UOPcQBJkzoX6+17JM9Q16qtIZ4Wyl/fEpqqEfnhQsSi+5KpLxD7WNeA43BUx1edC
# gl7PeNfiF4ARlYp4mZykQslg77l02HtRtnEVf74VkzhjBsAcvW60FWMgx2SGcPV1
# zP4UwdFHVyJjXPx//42Zp6AgbCQBcgcl3fSRpxSsObm4MYIB3DCCAdgCAQEwOzAn
# MSUwIwYDVQQDDBxkYXZpZGpvbmVzQHNwb3J0cm9uaWNzLmNvLmF1AhBrpAJHNjiW
# tkb5GGKRxPGuMAkGBSsOAwIaBQCgeDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAA
# MBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgor
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBSiAVlDQXy5xDyfKrk0AMyxCHM+cTAN
# BgkqhkiG9w0BAQEFAASCAQBxPKmPw7n5dMQkicwQ9N+EYy7sadxaULeksOL5qSml
# iw9Zf3GR5FV9T+QrtcKogOfQ0lEx9fFZ+Mdoc1WB4P67OZaOA44qTnzERD2ZN3i+
# S9JO5b+a49xGGMkkRK/8x2cUAToCgAAEMmxaZOmYYi2Jx7fUhD97ugz/89fKp5hB
# qcUjD5ijpxiRv13PTi96aNQxSBWLLQ5p3YrGn3LQiUj3HukuGJNN3mccN4+hjOL9
# bbgvYj5THFTSel3OZTGXIvTeOmRa50JkO/H0Q/8BEqUqqMk77FKLrGaa1BH9np9Q
# W/udTB3F3uEWOWC9WwFT4KvbDp4eORfCmqsRSm9aThSZ
# SIG # End signature block

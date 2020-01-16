param (
    [string]$Subscription = '' ,
    [string]$GroupName='',
    [string]$Location=''
)

$global:result3 = 'XX'
function Show-LocationMenu
{
    param (
        [string]$ListString, 
        [string]$DisplayIndex='0', 
        [string]$CodeIndex='4',
        [string]$Title='Location',
        [string]$CurrentSelection='Central US'
    )
    $ListString =  $global:LocationsStrn 
    if ([string]::IsNullOrEmpty($ListString))
    {
        $prompt = 'No ' +$Title +'s found. Exiting'
        write-Host $prompt
        return 'Exit'
    }    
    $com =$ListString  -split '\n'
    $com.Length
    [int] $i=1
    write-Host ''
    $prompt ='Select a ' + $Title
    write-Host $prompt

    $col=0
    foreach ($j in $com) 
    {
        if ([string]::IsNullOrEmpty($j))
        {   
            write-Host ''
            $i++        
            break
        }
        else {       
            $itemToList = ($j-split '\t')[$DisplayIndex]
        }
        [string]$prompt = [string]$i
        $prompt += '. '     
        $prompt +=  $itemToList
        $prompt = [string]::Format("{0,-24}",$prompt )
        if ( $itemToList -eq $CurrentSelection)
        {
            write-Host ''
            [string]$prompt = [string]$i
            $prompt += '. '   
            write-Host $prompt -NoNewline
            $prompt = [string]::Format("{0,-22}",$itemToList )
            write-Host $itemToList -BackgroundColor Yellow -ForegroundColor Blue -NoNewline
            write-Host ' <-- Current Selection' -ForegroundColor DarkGreen 
            $col = 0
        }
        else 
        {
            
            write-Host $prompt -NoNewline
        

            if ($col -eq 3)
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



    write-Host ''
    [string]$prompt = [string]$i
    $prompt += '. '
    $prompt +=  'Back '
    write-Host $prompt
    $i++
    [string]$prompt = [string]$i
    $prompt += '. '
    $prompt +=  'Exit '
    write-Host $prompt
    
    [int]$selection =1
    $prompt ="Please make a (numerical) selection .. Or [Enter] if previous selection highlighted."
    do 
    {
        [int] $selection = 0
        $answer = read-host $prompt
        if($answer -eq '-1')
        {
            # Just in case the user enters -1!
            $selection = 0
        }
        elseif (([string]::IsNullOrEmpty($answer)) -AND( $CurrentSelection -ne ''))
        {
            #Flag enter pressed so use $CurrentSelection
            $selection  = -1
        }
        elseif ([string]::IsNullOrEmpty($answer)) 
        {
            $selection  = 0
        }
        else 
        {
            $selection = [int]$answer
        }
        $prompt = "Please make a VALID selection."

    } until (`
         ($selection -gt 0) -and (($selection  -le  $i) `
            -and ($selection  -ne  ($i -4)) ) `
         -OR ($selection -eq -1))

    $output = ''
    if ($selection -eq -1)
    {
        $output = $CurrentSelection
    }
    elseif ($selection -eq  $i-1)
    {
        $output = 'Back'
    }
    elseif ($selection -eq  $i)
    {
        $output = 'Exit'
    }
    else 
    {          
        $com2 =($ListString-split '\n')[$selection-1]
        $output =  ($com2-split '\t')[$CodeIndex]   
    }
    write-Host ''
    $promptFinal = 'Location "' +  $output + '" selected'
    write-Host $promptFinal
    $global:result3 = $output
    return $output
}

clear-Host
# Need a group name
if ([string]::IsNullOrEmpty($GroupName))
{
    do
    {
        $prompt = 'Enter Resource Group Name, X to exit/return'
        $answer= read-Host $prompt
        write-Host $answer
        
    } until (-not ([string]::IsNullOrEmpty($answer)))
    if ($answer.ToUpper() -eq 'X')
    {
        write-Host 'Returning'
        return
    }
    $GroupName = $answer
}
# Need a location
if ([string]::IsNullOrEmpty($Location))
{
    if ([string]::IsNullOrEmpty($global:LocationsStrn))
    {
        $global:LocationsStrn = az account list-locations  -o tsv | Out-String
    }
    [string]$result =  Show-LocationMenu 
    $Location = $global:result3 
    write-Host $Location
    if ($Location -eq 'Back')
    {
        return 'Back'
    }
    elseif ($Location -eq 'Exit')
    {
        return 'Exit'
    }
}
# exit

# Subscription is  optional
if ([string]::IsNullOrEmpty($Subscription)) 
{
    $prompt = 'Checking whether Azure Group "' + $GroupName  +'" exists.'
    write-Host $prompt
    if (  ( az group exists --name $GroupName   ) -eq $false)
    {
        $prompt = 'Creating new Azure Resource Group "' + $GroupName + '" at location "' + $Location +'"'
        write-Host $prompt
        az group create --name $GroupName --location $Location
    }
    else 
    {
        $prompt = 'Azure Resource Group "' + $GroupName +'" already exists. Returning'
        write-Host $prompt
        return $GroupName + ' AlreadyExists'
    }

    $prompt = 'Checking whether Azure Group "' + $GroupName   +'" was created.'
    write-Host $prompt
    if (  ( az group exists --name $GroupName   ) -eq $false)
    {
        $prompt = 'It Failed'
        write-Host $prompt
        return $GroupName + ' Failed'
    }
    else 
    {
        $prompt = 'It was created.'
        write-Host $prompt
    }
}
else 
{
    $prompt = 'Checking whether Azure Group "' + $GroupName  + '" in Subscription "' + $Subscription +'" exists.' + '# at location "' + $Location +'"'
    write-Host $prompt
    if (  ( az group exists --name $GroupName  --subscription $Subscription) -eq $false)
    {
        $prompt = 'Creeating new Azure Resource Group "' + $GroupName +'"'
        write-Host $prompt
        az group create --name $GroupName --location $Location --subscription $Subscription) 
    }
    else 
    {
        $prompt = 'Azure Resource Group "' + $GroupName +'" already exists. Returning.'
        write-Host $prompt
        return $GroupName + ' AlreadyExists'
    }
    $prompt = 'Checking whether Azure Group "' + $GroupName  + '" in Subscription "' + $Subscription +'" was craeted.'
    write-Host $prompt
    if (  ( az group exists --name $GroupName  --subscription $Subscription) -eq $false)
    {
        $prompt = 'It Failed'
        write-Host $prompt
        return $GroupName + ' Failed'
    }
    else 
    {
        $prompt = 'It was created.'
        write-Host $prompt
    }
    return $GroupName +' OK'
}


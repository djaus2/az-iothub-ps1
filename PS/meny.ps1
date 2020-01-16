$subscriptionsStrn =''

function Show-Menu2{

        param (
      [Parameter(Mandatory)]
        [string]$ListString, 
      [Parameter(Mandatory)]
        [string]$Index, 
      [Parameter(Mandatory)]
        [string]$Title
    )

    clear
    $hubst = $ListString
    $com =$hubst -split '\n'
    [int] $i=1
    Write-Output ''
    $prompt ='Select a ' + $Title
    Write-Output $prompt
    foreach ($j in $com) 
    {
        #If ([string]::IsNullOrEmpty($j))
        #{   
            #$i++         
            #break
        #}
        [string]$prompt = [string]$i
        $prompt += '. '
        $prompt +=  ($j-split '\t')[$Index]
        write-Output $prompt
        $i++
    }
    [string]$prompt = [string]$i
    $prompt += '. '
    $prompt +=  'New ' + $Title
    write-Output $prompt
    return 'ABC' 
    
}

function Show-Menu{

        param (
      [Parameter(Mandatory)]
        [string]$ListString, 
      [Parameter(Mandatory)]
        [string]$Index, 
      [Parameter(Mandatory)]
        [string]$Title
    )

    clear
    $hubst = $ListString
    $com =$hubst -split '\n'
    [int] $i=1
    Write-Output ''
    $prompt ='Select a ' + $Title
    Write-Output $prompt
    foreach ($j in $com) 
    {
        #If ([string]::IsNullOrEmpty($j))
        #{   
            #$i++         
            #break
        #}
        [string]$prompt = [string]$i
        $prompt += '. '
        $prompt +=  ($j-split '\t')[$Index]
        write-Output $prompt
        $i++
    }
    [string]$prompt = [string]$i
    $prompt += '. '
    $prompt +=  'New ' + $Title
    write-Output $prompt
     
    
    $answer = read-host "Please make a Selection"
    [int]$selection = [int]$answer

    $com2 =($hubst -split '\n')[$selection-1]
    $output =  ($com2-split '\t')[$Index]
    write-Output ''
    $promptFinal = $output + ' selected'
    write-Output $promptFinal

    return $output
}

$subscriptionsStrn =''
$subscription = ''
If ([string]::IsNullOrEmpty($subscriptionsStrn))
{   write-Output 'Getting Subscriptions from Azure'
    $subscriptionsStrn =  az account list  -o tsv | Out-String
}
$subscription = Show-Menu $subscriptionsStrn 3  'Subscription'
write-Output $subscription

$GroupsStrn = ''
$Group= ''
If ([string]::IsNullOrEmpty($GroupsStrn ))
{   
    write-Output 'Getting Groups from Azure'
    $GroupsStrn =  az group list  -o tsv | Out-String
}
$Group = Show-Menu $GroupsStrn 4  'Group'
write-Output $Group

$HubsStrn = ''
$Hub= ''
If ([string]::IsNullOrEmpty($HubStrn ))
{   
    write-Output 'Getting Hubs from Azure'
    $hubStrn =  az group list  -o tsv | Out-String
}
$Hub = Show-Menu $HubsStrn 4  'Hub'
write-Output $Hub

$DevicesStrn = ''
$Device = ''
If ([string]::IsNullOrEmpty($HDeviceStrn ))
{   
    write-Output 'Getting Devices from Azure'
    $DevicesStrn =  az iot hub device-identity list -o tsv | Out-String
}
$Device = Show-Menu $DevicesStrn 4  'Hub'
write-Output $Device
    

$hubst =  az group list  -o tsv | Out-String
$group = Show-Menu $hubst 3  'Resource Group'
write-Output $group

exit

$com =$hubst -split '\n'
[int] $i=1
Write-Output ''
Write-Output 'Select Azure Subscription'
foreach ($j in $com) 
{
    [string]$prompt = [string]$i
    $prompt += '. '
    $prompt +=  ($j-split '\t')[3]
    write-Output $prompt
    $i++
}
    [string]$prompt = [string]$i
    $prompt += '. '
    $prompt +=  'New Hub'
    write-Output $prompt 


$hubst =  az group list  -o tsv | Out-String
$com =$hubst -split '\n'
[int] $i=1
Write-Output ''
Write-Output 'Select Azure Subscription'
foreach ($j in $com) 
{
    [string]$prompt = [string]$i
    $prompt += '. '
    $prompt +=  ($j-split '\t')[3]
    write-Output $prompt
    $i++
}
    [string]$prompt = [string]$i
    $prompt += '. '
    $prompt +=  'New Hub'
    write-Output $prompt


$hubst = az iot hub list  -o tsv | Out-String
$com =$hubst -split '\n'
[int] $i=1
Write-Output ''
Write-Output 'Select IoT Hub'
foreach ($j in $com) 
{
    [string]$prompt = [string]$i
    $prompt += '. '
    $prompt +=  ($j-split '\t')[3]
    write-Output $prompt
    $i++
}
    [string]$prompt = [string]$i
    $prompt += '. '
    $prompt +=  'New Hub'
    write-Output $prompt 

$hubst =az iot hub device-identity list -o tsv | Out-String
$com =$hubst -split '\n'
[int] $i=1
Write-Output ''
Write-Output 'Select IoT Hub'
foreach ($j in $com) 
{
    [string]$prompt = [string]$i
    $prompt += '. '
    $prompt +=  ($j-split '\t')[3]
    write-Output $prompt
    $i++
}
    [string]$prompt = [string]$i
    $prompt += '. '
    $prompt +=  'New Hub'
    write-Output $prompt 


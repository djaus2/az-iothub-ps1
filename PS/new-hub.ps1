param (
    [string]$Subscription = '' ,
    [string]$GroupName='',
    [string]$HubName=''
)




clear-Host
# Need a group name
if ([string]::IsNullOrEmpty($GroupName))
{
    do
    {
        $prompt = 'Enter Resource Group Name, X to exit/return'
        $answer= read-Host $prompt
        $answer = $answer.Trim()
        write-Host $answer
        
    } until (-not ([string]::IsNullOrEmpty($answer)))
    if ($answer.ToUpper() -eq 'X')
    {
        write-Host 'Returning'
        return
    }
    $GroupName = $answer
}
#Need a Hub Name
if ([string]::IsNullOrEmpty($HubName))
{
    do
    {
        $prompt = 'Enter IoT Hub Name, X to exit/return'
        $answer= read-Host $prompt
        $answer = $answer.Trim()
        write-Host $answer
        
    } until (-not ([string]::IsNullOrEmpty($answer)))
    if ($answer.ToUpper() -eq 'X')
    {
        write-Host 'Returning'
        return
    }
    $HubName = $answer
}


# exit

# Subscription is  optional
if ([string]::IsNullOrEmpty($Subscription)) 
{
    $prompt = 'Checking whether Azure IoT Hub "' + $HubName  +'" exists in Group "' + $GroupName + '"'
    write-Host $prompt
  
    write-Host 'Getting Hubs from Azure'
    $global:HubsStrn =  az iot hub list --resource-group  $GroupName  -o tsv | Out-String
    If ([string]::IsNullOrEmpty($global:HubsStrn ))
    {   
        $Index = 3
        $com =$global:HubsStrn -split '\n'
        foreach ($j in $com) 
        {
            $j
            if ([string]::IsNullOrEmpty($j))
            {   
                continue
            }
            $itemToList = ($j-split '\t')[$Index]
            if ($itemToList -eq $HubName)
            {
                $prompt = 'Azure IoT Hub "' + $HubName +'" in Group "' + $GroupName + '" already exists. Returning'
                write-Host $prompt
                return
            }
        }
    }
    else 
    {
        $prompt = "No hubs found ... Continuing."
        write-Host $prompt
    }

    $prompt = 'Creating new Azure IoT Hub "' + $HubName +'" in Group "' + $GroupName + '"'
    write-Host $prompt
    az iot hub create --name $HubName   --resource-group $GroupName --sku 'S1'
   
# az iot hub delete --name qaz   --resource-group AzSpheerGroup
    $prompt = 'Checking whether Azure IoT Hub "' + $HubName +'" in Group "' + $GroupName + '" was created.'
    write-Host $prompt
    write-Host 'Getting Hubs from Azure'
    $global:HubsStrn =  az iot hub list --resource-group  $GroupName  -o tsv | Out-String
    If ([string]::IsNullOrEmpty($global:HubsStrn ))
    {   
        $Index = 3
        $com =$hubst -split '\n'
        foreach ($j in $com) 
        {
            if ([string]::IsNullOrEmpty($j))
            {   
                continue
            }
            $itemToList = ($j-split '\t')[$Index]
            if ($itemToList -eq $HubName)
            {
                $prompt = 'It was created'
                write-Host $prompt
                return
            }
        }
        $prompt = 'Hub not created.'
        write-Host $prompt
    }
    else 
    {
        $prompt = 'Hub not created.'
        write-Host $prompt
    }
}

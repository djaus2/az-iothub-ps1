param (
    [string]$Subscription = '' ,
    [string]$GroupName='',
    [string]$Location=''
)

Clear-Host
write-Host ' AZURE IOT HUB SETUP: ' -NoNewline
write-Host '  N E W  G R O U P  '  -BackgroundColor DarkBlue  -ForegroundColor White -NoNewline
write-Host ' using PowerShell'
write-Host ''

$global:GroupName = $null

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
        return 'Return'
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
    [string]$result =  show-menu $global:LocationsStrn  Location 0 4 22
    $Location = $result 
    $prompt = 'Location "' +$result +'" returned'
    write-Host $prompt
    if ($Location -eq 'Back')
    {
        return 'Back'
    }
    elseif ($Location -eq 'Exit')
    {
        Exit
    }
}
# exit

$global:GroupsStrn = $null
$global:GroupName = $null

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
        return 'Exists'
    }

    $prompt = 'Checking whether Azure Group "' + $GroupName   +'" was created.'
    write-Host $prompt
    if (  ( az group exists --name $GroupName   ) -eq $false)
    {
        $prompt = 'It Failed. Exiting'
        write-Host $prompt
        Exit
    }
    else 
    {
        $prompt = 'It was created.'
        write-Host $prompt
        $global:GroupName =$GroupName
        return $GroupName
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
        az group create --name $GroupName --location $Location --subscription $Subscription 
    }
    else 
    {
        $prompt = 'Azure Resource Group "' + $GroupName +'" already exists. Returning.'
        write-Host $prompt
        return 'Exists'
    }
    $prompt = 'Checking whether Azure Group "' + $GroupName  + '" in Subscription "' + $Subscription +'" was craeted.'
    write-Host $prompt
    if (  ( az group exists --name $GroupName  --subscription $Subscription) -eq $false)
    {
        $prompt = 'It Failed. Exiting'
        write-Host $prompt
        exit
    }
    else 
    {
        $prompt = 'It was created.'
        write-Host $prompt
        $global:GroupName = $GroupName
        return $GroupName
    }
  
}


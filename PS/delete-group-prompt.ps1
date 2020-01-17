param (
    [string]$GroupName=''
)
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
$prompt =  'Do you want to delete the group "' + $GroupName +  '" Y/N (Default N)'
$answer = read-Host $prompt
if  (($answer -eq 'N') -OR ($answer -eq 'n'))
{
    return
}


$prompt = 'Checking whether Azure Group "' + $GroupName  + '" exists.'
write-Host $prompt
if (  ( az group exists --name $GroupName   ) -eq $true)
{
    $prompt = 'Deleting Azure Resource Group "' + $GroupName + '"'
    write-Host $prompt
    az group delete --name $GroupName
}
else 
{
    $prompt = 'Azure Resource Group "' + $GroupName +'" doesnt exist. Returning'
    write-Host $prompt
    return
}

$prompt = 'Checking whether Azure Group "' + $GroupName   +'" was deleted.'
write-Host $prompt
if (  ( az group exists --name $GroupName   ) -eq $true)
{
    $prompt = 'It Failed'
    write-Host $prompt
    return 
}
else 
{
    $prompt = 'It was deleted.'
    write-Host $prompt
}

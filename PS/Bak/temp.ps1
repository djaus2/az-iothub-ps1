Menu2 $subscriptionsStrn 3  'Subscription'
$answer = read-host "Please make a Selection"
[int]$selection = [int]$answer

$com2 =($hubst -split '\n')[$selection-1]
$output =  ($com2-split '\t')[$Index]
write-Output ''
$promptFinal = $output + ' selected'

$subscription =  $output
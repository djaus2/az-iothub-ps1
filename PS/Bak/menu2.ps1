
function Menu2 {
        param (
      [Parameter(Mandatory)]
        [string]$ListString, 
      [Parameter(Mandatory)]
        [string]$Index, 
      [Parameter(Mandatory)]
        [string]$Title
    )

    cls
    $hubst = $ListString
    $com =$hubst -split '\n'
    [int] $i=1
    Write-Output ''
    $prompt ='Select a ' + $Title
    Write-Output $prompt
    foreach ($j in $com) 
    {
        If ([string]::IsNullOrEmpty($j))
        {   
            $i++         
            break
        }
        [string]$prompt = [string]$i
        $prompt += '. '
        $prompt +=  ($j-split '\t')[$Index]
        echo $prompt
        $i++
    }
    [string]$prompt = [string]$i
    $prompt += '. '
    $prompt +=  'New ' + $Title
    write-Output $prompt
    $answer = read-host "Please Make a Selection" 
  }
 
   Menu2 aaa 3 bbb
    


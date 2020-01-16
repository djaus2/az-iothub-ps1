$addPath =  $pwd.Path 
   if (Test-Path $addPath){
        $regexAddPath = [regex]::Escape($addPath)
        $arrPath = $env:Path -split ';' | Where-Object {$_ -notMatch "^$regexAddPath\\?"}
        $env:Path = ($arrPath + $addPath) -join ';'
	    $env:Path -split ';'
    } else {
        Throw "'$addPath' is not a valid path."
    }
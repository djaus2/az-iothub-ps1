$baseMenu =@()
$selns={$baseMenu}.Invoke()
function AddKey
{
param (
   [Parameter(Mandatory)]
    [int]$no
)
    switch ($no)
    {
        0  {$selns.Add({D0}) }
        1  {$selns.Add({D1}) }
        2  {$selns.Add({D2}) }
        3  {$selns.Add({D3}) }
        4  {$selns.Add({D4}) }
        5  {$selns.Add({D5}) }
        6  {$selns.Add({D6}) }
        7  {$selns.Add({D7}) }
        8  {$selns.Add({D8}) }
        9  {$selns.Add({D9}) }
    }
}
for ($i=0;$i-le 6;$i++)
{
    AddKey $i
}
foreach ($z in $selns) {$z}
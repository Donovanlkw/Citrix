
### ---  combine two Array variable into a Table --- ###
$report =@()
$first = @(1,2,3,4,5)
$second = @(6, 7,8,9,10)

$report= for($i= 0; $i -lt $first.count; $i++) {  
#write-Verbose "$first[$i],$Second[$i])"

[PSCustomObject]@{
first= $first[$i]
Second= $Second[$i]
}
}

$report

### ---  combine two Array variable into a Table --- ###















$array = @()
$array += $obj


#----- Array Appraoch#1 
$updateFeatures = @(
  'UpdateServices-WidDB',
  'UpdateServices-Services',
  'UpdateServices-RSAT',
)
Write-Output $updateFeatures
#Install-WindowsFeature -Name $updateFeatures

#----- Array Appraoch#2
$Directory= 'D:SRSReportKeys', 'F:MSSQL', 'F:MSSQLTempDB', 'F:MSSQLUserDB', 'G:MSSQL', 'G:MSSQLUserDBLOG', 'G:MSSQLTempDBLogs', 'G:MSSQLBackup'
$Directory|foreach-object{
New-Item $_ -Type Directory
$NewAcl = Get-Acl -Path $_
Set-Acl -Path $_ -AclObject $NewAcl
}

### ---  combine two Array variable into a Table --- ###
$report =@()
$first = @(1,2,3,4,5)
$second = @(6, 7,8,9,10)

$report= for($i= 0; $i -lt $first.count; $i++) {  
[PSCustomObject]@{
first= $first[$i]
Second= $Second[$i]
}
}

$report

### ---  combine two Array variable into a Table --- ###















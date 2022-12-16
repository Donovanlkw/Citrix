### --- Common Variable --- ###
$Env: 
$env:userdnsdomain 
$Env:COMPUTERNAME 
$FQNDServerName= [System.Net.Dns]::GetHostByName($env:computerName).HostName 



$array = @()
$array += $obj
#----- Array Appraoch#1 
$updateFeatures = @(
  'UpdateServices-WidDB',
  'UpdateServices-Services',
  'UpdateServices-RSAT'
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


$reportMC =@()
$VM_DDC_XA|ForEach{
$resultMC=Get-ProvScheme -AdminAddress $_ |where {$_.machinecount -gt 0}  |sort-Object MasterImageVMDate

  $reportMC =@()
  $reportMC= for($i= 0; $i -lt $ResultMC.count; $i++) {  
    [PSCustomObject]@{
    MC= $resultMC[$i].IdentityPoolName
    ImageUpdate = $resultMC[$i].MasterImageVMDate
    Snapshot= split-path -path $resultMC[$i].MasterImageVM -leaf
    }
  }
$reportMC
}




### --- Variable --- ###
$OBJ= New-Object -TypeName PSObject
$OBJ | Add-Member -Name 'Name' -MemberType Noteproperty -Value 'Joe'
$OBJ | Add-Member -Name 'Age' -MemberType Noteproperty -Value 32

#----- common command
get-command  -Verb get -noun AD*Service*
Import-module 
Get-help * 
Get-history


Get-Variable | Out-String 

|Format-Table -AutoSize  
|Out-GridView
|FT  
|ConvertTo-Json |Out-file 'C:\test.json' 

#----- Sample Script              
Get-service | where-object {$_.status -eq "Running"} | Start-service 
Get-Service | where {$_.Name -like "S*"}               
Get-Service | where {$_.DisplayName -like "*S*"}             
Get-Service | where {($_.Name -like "S*")-and ($_.Status -eq "Running")} 

Get-ChildItem |where {$_.name -like "a*"}        
Get-ADGroup-Filter '*' -properties * |select-object * | where-object {$_.description -like "AAROMyWP*"} |select Name  
Get-ADGROUPmember GroupName |get-ADUser -properties * | Select Name,Created 

-eq    Means: equal Example: -eq "Running" Not support * symbol, only need to type full name 
-le    Means: less or equal       Example: -le 300 (Less or equal 200) or (<=300) 
-lt    Means: less than    Example: -lt 200 (Less than 200) or (<200) 
-like  Means: like  Example: -like "Running"or -like "Run*" or -like "*unnin* 
-notlike     Means: not like     Example: -notlike "stopped" or -notlike "St*" or -notlike "*oppe*" 
-ge    Means: Greater or equal    Example: -ge 200 (Greater or equal to 200) or (>=200) 
-gt    Means: Greater than Example: -gt 200 (Greater than 200) or (>200) 


  
###--- Output  ---###

Write-Host 
Write-Output 
Write-Error 

###--- Output  ---###


################ Logic ################

$StartTime=Get-Date -Year 2019 -Month 11 -Day 1 -Hour 00 -Minute 00
$EndTime=Get-Date -Year 2020 -Month 11 -Day 1 -Hour 00 -Minute 00
$hostname="vwts19bk-easd12"

https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comparison_operators?view=powershell-7.3

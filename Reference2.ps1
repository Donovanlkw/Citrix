# ----- Variable ----#
$OBJ= New-Object -TypeName PSObject
$OBJ | Add-Member -Name 'Name' -MemberType Noteproperty -Value 'Joe'
$OBJ | Add-Member -Name 'Age' -MemberType Noteproperty -Value 32

$array = @()
$array += $obj




#----- Array Appraoch#1   
$updateFeatures = @(   
  'UpdateServices-WidDB',  
  'UpdateServices-Services',  
  'UpdateServices-RSAT',  
  'UpdateServices-API',  
  'UpdateServices-UI'  
)   

Write-Output $updateFeatures  
Install-WindowsFeature -Name $updateFeatures  

#----- Array Appraoch#2  
$Directory= 'D:SRSReportKeys', 'F:MSSQL', 'F:MSSQLTempDB', 'F:MSSQLUserDB', 'G:MSSQL', 'G:MSSQLUserDBLOG', 'G:MSSQLTempDBLogs', 'G:MSSQLBackup'   


$Directory|foreach-object{   
New-Item $_ -Type Directory 
$NewAcl = Get-Acl -Path $_  
Set-Acl -Path $_ -AclObject $NewAcl   
}  

################ Date ################  

$StartTime=Get-Date -Year 2019 -Month 11 -Day 1 -Hour 00 -Minute 00  
$EndTime=Get-Date -Year 2020 -Month 11 -Day 1 -Hour 00 -Minute 00  
$hostname="vwts19bk-easd12"  

#----- Object Handling -----#  
Compare-Object -ReferenceObject $(Get-Content C:\test\testfile1.txt) -DifferenceObject $(Get-Content C:\test\testfile2.txt)                          


#----- File Handling -----#        
Measure-Command {Get-ChildItem -Path C:\Windows\*.txt -Recurse}                  
Get-ChildItem -path c:\tmp–Recurse| Measure-Object -Property length -Minimum -Maximum -Average                

#----- Read the content of file  
Get-Content -Path $file| Format-Table -AutoSize  
 
#----- create a local file for schedule task  

New-Item $file -force  
Add-content $file 'ServerManager'  
Add-content $file 'Start-Sleep -s 300'  
Add-Content $file '$BrokerServer="' -NoNewline  
Add-Content $file "$BrokerServer" -NoNewline  
Add-Content $file '"'  
Add-Content $file '  


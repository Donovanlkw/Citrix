|Format-Table -AutoSize  
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

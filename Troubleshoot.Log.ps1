$userid=""
$VDA=""
$ComputerName = Get-Content serverlist.txt
$id =""
$ProviderName =""

$StartTime=(Get-date).AddDays(-1)
$EndTime= ($StartTime).AddDays(1)
$StartTime
$EndTime

### --- Unknown error/warning log.
$ComputerName | Foreach-object {
$unknownSysErr=Get-WinEvent -computername $_ -FilterHashtable @{LogName='System';ProviderName=$ProviderName;StartTime=$StartTime;EndTime=$EndTime;id=$id} |where-object{$_.level -ne 4}|Select-Object -First 100
$unknownAppErr=Get-WinEvent -computername $_ -FilterHashtable @{LogName='Application';ProviderName=$ProviderName;StartTime=$StartTime;EndTime=$EndTime;id=$id} |where-object{$_.level -ne 4}|Select-Object -First 100
$unknownSysErr
$unknownAppErr 
}

$Alllog= $ComputerName | Foreach-object {
Get-WinEvent -computername $_ -FilterHashtable @{LogName='System';ProviderName=$ProviderName;StartTime=$StartTime;EndTime=$EndTime;id=$id} |where-object{$_.level -ne 4}|Select-Object -First 100
Get-WinEvent -computername $_ -FilterHashtable @{LogName='Application';ProviderName=$ProviderName;StartTime=$StartTime;EndTime=$EndTime;id=$id} |where-object{$_.level -ne 4}|Select-Object -First 100
}
$Alllog |select MachineName, LogName, Provide,id,TimeCreated,Message |format-table
$Alllog.message

### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- 
#----- Get the RDS Logon in last 7 days-----# 
$StartTime=(Get-date).AddDays(-7)
$EndTime= Get-date
$LogName="Security"
$eventid="4624"
$hostname=$env:computername

$Winevent=Get-WinEvent -ComputerName $hostname -FilterHashTable @{LogName=$LogName;ID=$eventid;StartTime=$StartTime;EndTime=$EndTime} 
$Events =$winevent | ?{$_.Message -match 'logon type:\s+(10)\s'}| ForEach-Object {
    $Values = $_.Properties | ForEach-Object { $_.Value }
    
    # return a new object with the required information
    [PSCustomObject]@{
        Time      = $_.TimeCreated
        # index 0 contains the name of the update
        Event     = $Values[0]
	UserID	= $Values[5]
    }
}

$Events | Format-Table -AutoSize


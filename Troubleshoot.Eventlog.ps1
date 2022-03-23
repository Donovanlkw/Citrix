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

##########################################################
#----- get the event from application log. 
$LogName="Application" 
$FileName="Application" 
$GE2=Get-WinEvent   -ComputerName $hostname -FilterHashtable @{LogName=$LogName;Level='2';StartTime=$StartTime;EndTime=$EndTime}  -MaxEvents  100 
$GE2 | export-csv "$hostname-$FileName-2.csv" 
$GE3=Get-WinEvent   -ComputerName $hostname -FilterHashtable @{LogName=$LogName;Level='3';StartTime=$StartTime;EndTime=$EndTime}  -MaxEvents  100 
$GE3 | export-csv "$hostname-$FileName-3.csv"  

$Winevent=Get-WinEvent -ComputerName $hostname -FilterHashTable @{LogName=$LogName;ID=$eventid;StartTime=$StartTime;EndTime=$EndTime}   



##########################################################

$Begin = Get-Date -Date '1/22/2022 00:00:00'
$End = Get-Date -Date '1/23/2022 00:00:00'
Get-EventLog -LogName System -EntryType Error -After $Begin -Before $End -computername abc |export-csv genp01.csv

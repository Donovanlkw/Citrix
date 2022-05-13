#----- Execute a command -----#  
Start-Process -path 'C:\Program Files (x86)\Google\Chrome\ Application\chrome.exe'


#----- Others -----#  
Get-service |where-object {$_.status -eq "Running"} | Start-service
Get-eventlog-LogName application
Get-eventlog-LogName system
Get-ADGroup-Filter '*' -properties * |select-object * | where-object {$_.description -like "AAROMyWP*"} |select Name 
Get-ADGROUPmember GroupName |get-ADUser -properties * | Select Name,Created

#Sample Script		
Get-Service | where {$_.Status -eq "Running"}		
Get-Service | where {$_.Name -like "S*"}		
Get-Service | where {$_.DisplayName -like "*S*"}		
Get-Service | where {($_.Name -like "S*")-and ($_.Status -eq "Running")}			
Get-ChildItem |where {$_.name -like "a*"}		
		
-eq	Means: equal	Example: -eq "Running" Not support * symbol, only need to type full name
-le	Means: less or equal	Example: -le 300 (Less or equal 200) or (<=300)
-lt	Means: less than	Example: -lt 200 (Less than 200) or (<200)
-like	Means: like	Example: -like "Running"or -like "Run*" or -like "*unnin*
-notlike	Means: not like	Example: -notlike "stopped" or -notlike "St*" or -notlike "*oppe*"
-ge	Means: Greater or equal	Example: -ge 200 (Greater or equal to 200) or (>=200)
-gt	Means: Greater than	Example: -gt 200 (Greater than 200) or (>200)

Write-Host
Write-Output
Write-Error


################ Input  ################
param (
    [Parameter(Mandatory=$false)]
    [String] $vmName = "vwts19bk-easd00",
    [Parameter(Mandatory=$false)]
    [String] $VMSize = "Standard D2s v2"
)

catch {
    if (!$servicePrincipalConnection)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}



############## Parameter pass to extension script ##############
$argument = " -brokerServer $BrokerServer -CollectionName $CollectionName -user $DomainuserName -pwd $Domainpassword -task $task "
$argument = $argument + " -vmssName $VMSSName "
$argument = $argument + " -FQDNVIP $FQDNVIP -sqlserver $sqlserver -sqldb $sqldb -sqladmin $sqluserName -sqlpwd $sqlpassword"


############## Credential ##############
#$adminCredential = Get-AutomationPSCredential -Name 'AdminUser'
#$adminuserName = $adminCredential.UserName
#$adminsecurePassword = $adminCredential.Password
#$adminpassword = $adminCredential.GetNetworkCredential().Password

#----- Create a schedule Task in Admin. Tools.
$file = "c:\temp\$task.ps1"

Get-ScheduledTask
$resumeActionscript = "-WindowStyle Normal -NoLogo -NoProfile -File $file"
$act = New-ScheduledTaskAction -Execute "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -Argument $resumeActionscript
$trig = New-ScheduledTaskTrigger -AtStartup
Register-ScheduledTask -TaskName $task -user $user -password $pwd -Action $act -Trigger $trig -RunLevel Highest

### create a local file for schedule task
New-Item $file -force
Add-content $file 'ServerManager'
Add-content $file 'Start-Sleep -s 300'

Add-Content $file '$BrokerServer="' -NoNewline
Add-Content $file "$BrokerServer" -NoNewline
Add-Content $file '"'

Add-Content $file '
'


################ Logic ################

$StartTime=Get-Date -Year 2019 -Month 11 -Day 1 -Hour 00 -Minute 00
$EndTime=Get-Date -Year 2020 -Month 11 -Day 1 -Hour 00 -Minute 00
$hostname="vwts19bk-easd12"



#----- #----- #----- #----- #----- #----- #----- #----- #----- #----- #----- 



#----- Ojbect Handling -----#
Compare-Object -ReferenceObject $(Get-Content C:\test\testfile1.txt) -DifferenceObject $(Get-Content C:\test\testfile2.txt)				

#----- File Handling -----#    	
Measure-Command {Get-ChildItem -Path C:\Windows\*.txt -Recurse}			
Get-ChildItem -path c:\tmp–Recurse| Measure-Object -Property length -Minimum -Maximum -Average		


#----- Read the content of file
Get-Content -Path $file| Format-Table -AutoSize


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

Write-Host
Write-Output
Write-Error

############## Parameter pass to extension script ##############
$argument = " -brokerServer $BrokerServer -CollectionName $CollectionName -user $DomainuserName -pwd $Domainpassword -task $task "
$argument = $argument + " -vmssName $VMSSName "
$argument = $argument + " -FQDNVIP $FQDNVIP -sqlserver $sqlserver -sqldb $sqldb -sqladmin $sqluserName -sqlpwd $sqlpassword"


############## Credential ##############
#$adminCredential = Get-AutomationPSCredential -Name 'AdminUser'
#$adminuserName = $adminCredential.UserName
#$adminsecurePassword = $adminCredential.Password
#$adminpassword = $adminCredential.GetNetworkCredential().Password


param (
    [Parameter(Mandatory=$false)]
    [String] $vmssName,
	[Parameter(Mandatory=$false)]
    [String] $BrokerServer,
	[Parameter(Mandatory=$false)]
    [String] $CollectionName,
    [Parameter(Mandatory=$false)]
    [String] $user,
    [Parameter(Mandatory=$false)]
    [String] $pwd,
	[Parameter(Mandatory=$false)]
    [String] $task

)

$file = "c:\temp\$task.ps1"

### Reset security configuration
Add-LocalGroupMember -Group "Administrators" -Member $user
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services\" -Name "MinEncryptionLevel" 
set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\" -Name "DisableDomainCreds" -value "0"
set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -value "0"

### Create a auto run RDS Configuration
Get-ScheduledTask
$resumeActionscript = "-WindowStyle Normal -NoLogo -NoProfile -File $file"
$act = New-ScheduledTaskAction -Execute "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -Argument $resumeActionscript
$trig = New-ScheduledTaskTrigger -AtStartup
Register-ScheduledTask -TaskName $task -user $user -password $pwd -Action $act -Trigger $trig -RunLevel Highest

### create a local file for schedule task
New-Item $file -force
Add-content $file 'ServerManager'
Add-content $file 'Start-Sleep -s 300'

Add-Content $file '$BrokerServer="' -NoNewline
Add-Content $file "$BrokerServer" -NoNewline
Add-Content $file '"'

Add-Content $file '$VMSSASH = Get-rdserver |select-object Server |where server -like ' -NoNewline
Add-Content $file "$vmssName" -NoNewline
Add-Content $file '*'

Add-Content $file '
$VMSSASH |ForEach-Object {
Remove-RDSessionHost  -SessionHost $_.server -ConnectionBroker $BrokerServer  -force
Remove-RDServer       -Server $_.server -Role "RDS-RD-SERVER" -ConnectionBroker $BrokerServer -force
}
'

################ Event Log ################

$StartTime=Get-Date -Year 2019 -Month 11 -Day 1 -Hour 00 -Minute 00
$EndTime=Get-Date -Year 2020 -Month 11 -Day 1 -Hour 00 -Minute 00
$hostname="vwts19bk-easd12"


$LogName="Application"
$FileName="Application"
$GE2=Get-WinEvent   -ComputerName $hostname -FilterHashtable @{LogName=$LogName;Level='2';StartTime=$StartTime;EndTime=$EndTime}  -MaxEvents  100
$GE2 | export-csv "$hostname-$FileName-2.csv"
$GE3=Get-WinEvent   -ComputerName $hostname -FilterHashtable @{LogName=$LogName;Level='3';StartTime=$StartTime;EndTime=$EndTime}  -MaxEvents  100
$GE3 | export-csv "$hostname-$FileName-3.csv"


$LogName="Microsoft-Windows-RemoteDesktopServices-RdpCoreTS/Operational"
$FileName="Microsoft-Windows-RemoteDesktopServices-RdpCoreTS"

$GE2=Get-WinEvent   -ComputerName $hostname -FilterHashtable @{LogName=$LogName;Level='2';StartTime=$StartTime;EndTime=$EndTime}  -MaxEvents  100
$GE2 | export-csv "$hostname-$FileName-2.csv"
$GE3=Get-WinEvent   -ComputerName $hostname -FilterHashtable @{LogName=$LogName;Level='3';StartTime=$StartTime;EndTime=$EndTime}  -MaxEvents  100
$GE3 | export-csv "$hostname-$FileName-3.csv"



<#
### Reset security configuration
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services\" -Name "MinEncryptionLevel" 
set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\" -Name "DisableDomainCreds" -value "0"
set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -value "0"


### Reset security policy configuration
secedit /export /cfg c:\temp\secpolori.inf
(gc c:\temp\secpolori.inf).replace("SeServiceLogonRight =", "SeServiceLogonRight = *S-1-5-80-0,") | Out-File c:\temp\secpolnew.inf
(gc c:\temp\secpolori.inf).replace("SeServiceLogonRight =", "SeServiceLogonRight = *S-1-5-80-1184457765-4068085190-3456807688-2200952327-3769537534,") | Out-File c:\temp\secpolfinal.inf
secedit /configure /db C:\Windows\security\local.sdb /areas USER_RIGHTS /cfg  c:\temp\secpolnew.inf


### Restore security configuration
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services\"  -Name "MinEncryptionLevel" -Value "3"  -PropertyType "DWORD"
set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\" -Name "DisableDomainCreds" -value "1"
set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -value "1"
### Restore security policy configuration
secedit /configure /db C:\Windows\security\local.sdb /areas USER_RIGHTS /cfg  c:\temp\secpolfinal.inf
#>




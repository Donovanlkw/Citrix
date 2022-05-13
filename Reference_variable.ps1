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
#Install-WindowsFeature -Name $updateFeatures

#----- Array Appraoch#2
$Directory= 'D:SRSReportKeys', 'F:MSSQL', 'F:MSSQLTempDB', 'F:MSSQLUserDB', 'G:MSSQL', 'G:MSSQLUserDBLOG', 'G:MSSQLTempDBLogs', 'G:MSSQLBackup'
$Directory|foreach-object{
New-Item $_ -Type Directory
$NewAcl = Get-Acl -Path $_
Set-Acl -Path $_ -AclObject $NewAcl
}



Write-Host
Write-Output
Write-Error



Get-Variable | Out-String 

$Env: 
$env:userdnsdomain 
$Env:COMPUTERNAME 
$FQNDServerName= [System.Net.Dns]::GetHostByName($env:computerName).HostName 

#----- common command
get-command  -Verb get -noun AD*Service*
Import-module 
Get-help * 
Get-history


#----- Sample

#----- Create a schedule Task in Admin. Tools.  
$file = "c:\temp\$task.ps1"   
Get-ScheduledTask  
$resumeActionscript = "-WindowStyle Normal -NoLogo -NoProfile -File $file"  
$act = New-ScheduledTaskAction -Execute "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -Argument $resumeActionscript  
$trig = New-ScheduledTaskTrigger -AtStartup  
Register-ScheduledTask -TaskName $task -user $user -password $pwd -Action $act -Trigger $trig -RunLevel Highest  
  

$Events =$winevent | ?{$_.Message -match 'logon type:\s+(10)\s'}| ForEach-Object {  
    $Values = $_.Properties | ForEach-Object { $_.Value }  
    # return a new object with the required information   

    [PSCustomObject]@{  
        Time      = $_.TimeCreated  
        # index 0 contains the name of the update  
        Event     = $Values[0]  
       UserID = $Values[5] 
    }  
}  

$Events | Format-Table -AutoSize  
 

#----- Create a auto run RDS Configuration  

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

#----- Reset security configuration   
Add-LocalGroupMember -Group "Administrators" -Member $user  
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services\" -Name "MinEncryptionLevel"   
set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\" -Name "DisableDomainCreds" -value "0"  
set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -value "0"  
 

#----- Reset security policy configuration   
secedit /export /cfg c:\temp\secpolori.inf  
(gc c:\temp\secpolori.inf).replace("SeServiceLogonRight =", "SeServiceLogonRight = *S-1-5-80-0,") | Out-File c:\temp\secpolnew.inf  
(gc c:\temp\secpolori.inf).replace("SeServiceLogonRight =", "SeServiceLogonRight = *S-1-5-80-1184457765-4068085190-3456807688-2200952327-3769537534,") | Out-File c:\temp\secpolfinal.inf  
secedit /configure /db C:\Windows\security\local.sdb /areas USER_RIGHTS /cfg  c:\temp\secpolnew.inf  
 

#----- Restore security configuration  
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services\"  -Name "MinEncryptionLevel" -Value "3"  -PropertyType "DWORD"  
set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\" -Name "DisableDomainCreds" -value "1"  
set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -value "1"  

  

#----- Restore security policy configuration  
secedit /configure /db C:\Windows\security\local.sdb /areas USER_RIGHTS /cfg  c:\temp\secpolfinal.inf   

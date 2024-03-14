#----- Others -----#  
Get-service |where-object {$_.status -eq "Running"} | Start-service
Get-eventlog-LogName application
Get-eventlog-LogName system
Get-ADGroup-Filter '*' -properties * |select-object * | where-object {$_.description -like "AAROMyWP*"} |select Name 
Get-ADGROUPmember GroupName |get-ADUser -properties * | Select Name,Created

#----- File handling
#----- Object Handling -----#  
Compare-Object -ReferenceObject $(Get-Content C:\test\testfile1.txt) -DifferenceObject $(Get-Content C:\test\testfile2.txt)                          

#----- File Handling -----#        
Measure-Command {Get-ChildItem -Path C:\Windows\*.txt -Recurse}                  
Get-ChildItem -path c:\tmp–Recurse| Measure-Object -Property length -Minimum -Maximum -Average                

#----- Read the content of file  
Get-Content -Path $file| Format-Table -AutoSize  

#----- Execute a command -----#  
Start-Process -path 'C:\Program Files (x86)\Google\Chrome\ Application\chrome.exe'


############## Parameter pass to extension script ##############
$argument = " -brokerServer $BrokerServer -CollectionName $CollectionName -user $DomainuserName -pwd $Domainpassword -task $task "
$argument = $argument + " -vmssName $VMSSName "
$argument = $argument + " -FQDNVIP $FQDNVIP -sqlserver $sqlserver -sqldb $sqldb -sqladmin $sqluserName -sqlpwd $sqlpassword"


############## Credential ##############
#$adminCredential = Get-AutomationPSCredential -Name 'AdminUser'
#$adminuserName = $adminCredential.UserName
#$adminsecurePassword = $adminCredential.Password
#$adminpassword = $adminCredential.GetNetworkCredential().Password


### create a local file for schedule task
New-Item $file -force
Add-content $file 'ServerManager'
Add-content $file 'Start-Sleep -s 300'

Add-Content $file '$BrokerServer="' -NoNewline
Add-Content $file "$BrokerServer" -NoNewline
Add-Content $file '"'

Add-Content $file '
'



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



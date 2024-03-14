#----- Create a schedule Task in Admin. Tools.  
$file = "c:\temp\$task.ps1"   
Get-ScheduledTask  
$resumeActionscript = "-WindowStyle Normal -NoLogo -NoProfile -File $file"  
$act = New-ScheduledTaskAction -Execute "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -Argument $resumeActionscript  
$trig = New-ScheduledTaskTrigger -AtStartup  
Register-ScheduledTask -TaskName $task -user $user -password $pwd -Action $act -Trigger $trig -RunLevel Highest  

#----- Create a auto run RDS Configuration  

Get-ScheduledTask   
$resumeActionscript = "-WindowStyle Normal -NoLogo -NoProfile -File $file"   
$act = New-ScheduledTaskAction -Execute "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -Argument $resumeActionscript   
$trig = New-ScheduledTaskTrigger -AtStartup   
Register-ScheduledTask -TaskName $task -user $user -password $pwd -Action $act -Trigger $trig -RunLevel Highest  




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
############## 

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

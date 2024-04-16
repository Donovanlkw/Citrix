Citrix license 1	C:\Program Files (x86)\Citrix\Licensing\LS>udadmin -list -a
Citrix license 2	C:\Program Files (x86)\Citrix\Licensing\LS>udadmin -f XDT_PLT_UD -user AISVPIRANGUTE -delete
QFarm #List all servers in the XenApp farm	
QFarm /online #List all online servers	
QFarm /offline #List all offline servers	
QFarm /Zone EMEA /online #List online servers in EMEA zone	

  
Set-BrokerDesktopGroup -Name "Desktop groupname" -ShutdownDesktopsAfterUse $True
Set-BrokerDesktopGroup -Name "Desktop groupname" -AutomaticPowerOnForAssignedDuringPeak $True


Installed software
Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, | Format-Table –AutoSize
Get-WmiObject -Class win32reg_addremoveprograms | Select-Object displayName, Version



  
Get-ADGroup-Filter '*' -properties * |select-object * | where-object {$_.description -like "AAROMyWP*"} |select Name 
Get-ADGROUPmember GRP_CTX_App_VWLPC |get-ADUser -properties * | Select Name,Created
Get-XXX -Filter '*' -properties * | select-object * | where-object {$_.parameter -like "yyy"} |select Name

Get-XASession | Select-Object ServerName, AccountName | select ServerName, AccountName | Sort-Object -Property ServerName
Get-XAApplicationReport * | Where-Object -FilterScript {$_.Enabled -match "True" -and $_.FolderPath -notlike "*Healthcheck*"} | Where-Object -FilterScript {$_.Enabled -match "True" -and $_.FolderPath -notlike "*Testing*"} | Where-Object -FilterScript {$_.Enabled -match "True" -and $_.FolderPath -notlike "*Decomission*"} | Where-Object -FilterScript {$_.Enabled -match "True" -and $_.FolderPath -notlike "*Pre-production*"} |  Select-Object DisplayName, Accounts -expand accounts | select displayname, AccountDisplayName | Sort-Object -Property AccountDisplayName |more
Get-XASession | Where-Object -FilterScript {$_.Protocol -eq "ICA" } | Select-Object ServerName, AccountName | select ServerName, AccountName | Sort-Object -Property ServerName
Get-XASession | Where-Object -FilterScript {$_.Protocol -eq "ICA" } | Select-Object ClientName, AccountName  >> client.txt
Get-XAApplication -BrowserName Microsoft* | where-object {$_.Enabled -match "False"} | Format-Table DisplayName
Get-XAApplicationReport * |  Select-Object DisplayName, Accounts -expand accounts | select displayname, AccountDisplayName | Sort-Object -Property AccountDisplayName |more
Get-XAApplicationReport * |  where-object {$_.Enabled -match "False"}
Get-XAApplicationReport * |  where-object {$_.Enabled -match "True"}  |  Select-Object DisplayName, Accounts -expand accounts | select displayname, AccountDisplayName | Sort-Object -Property AccountDisplayName |more
Get-XAApplicationReport * |  where-object {$_.FolderPath -like "ABS"}
Get-XAApplicationReport * |  where-object {$_.FolderPath -notcontains "Healthcheck"}   |  Select-Object DisplayName, Accounts -expand accounts | select displayname, AccountDisplayName | Sort-Object -Property AccountDisplayName |more
Get-XAApplicationReport * |  where-object {$_.Enabled -match "True"}  {$_.FolderPath -notcontains "Healthcheck"}   |  Select-Object DisplayName, Accounts -expand accounts | select displayname, AccountDisplayName | Sort-Object -Property AccountDisplayName |more
Get-XAApplicationReport * |  where-object {$_.Enabled -match "True" -and $_.FolderPath -notlike "*Healthcheck*", "*Testing*", "*Decomission*", "*Pre-production*" }   |  Select-Object DisplayName, Accounts -expand accounts | select displayname, AccountDisplayName | Sort-Object -Property AccountDisplayName |more

Get-XAApplicationReport *
| Where-Object -FilterScript {$_.Enabled -match "True" -and $_.FolderPath -notlike "*Healthcheck*"}
| Where-Object -FilterScript {$_.Enabled -match "True" -and $_.FolderPath -notlike "*Testing*"}
| Where-Object -FilterScript {$_.Enabled -match "True" -and $_.FolderPath -notlike "*Decomission*"}
| Where-Object -FilterScript {$_.Enabled -match "True" -and $_.FolderPath -notlike "*Pre-production*"}
| Select-Object DisplayName, Accounts -expand accounts | select displayname, AccountDisplayName | Sort-Object -Property AccountDisplayName |more

Get-XAApplicationReport * | Where-Object -FilterScript {$_.Enabled -match "True" -and $_.FolderPath -notlike "*Healthcheck*"} | Where-Object -FilterScript {$_.Enabled -match "True" -and $_.FolderPath -notlike "*Testing*"} | Where-Object -FilterScript {$_.Enabled -match "True" -and $_.FolderPath -notlike "*Decomission*"} | Where-Object -FilterScript {$_.Enabled -match "True" -and $_.FolderPath -notlike "*Pre-production*"} |  Select-Object DisplayName, Accounts -expand accounts | select displayname, AccountDisplayName | Sort-Object -Property AccountDisplayName |more


"#List disconnected sessions
Get-XASession|SelectServerName,State,AccountName,BrowserName |Where{$_.State-eq""Disconnected""}|SortServerName

#List sessions matching more than one condition
Get-XASession|SelectServerName,State,AccountName,BrowserName |Where{$_.BrowserName-notlike""Desktop""-and$_.State-eq""Disconnected""}|SortServerName
#"


  XenApp 6.5 powershell commands cheat sheet	
#List disconnected sessions	Get-XASession |Select ServerName, State, AccountName, BrowserName |Where {$_.State -eq "Disconnected"} |Sort ServerName
#List sessions matching more than one condition	Get-XASession |Select ServerName, State, AccountName, BrowserName |Where {$_.BrowserName -notlike "Desktop" -and $_.State -eq "Disconnected"} |Sort ServerName
#List configured zones in the farm	Get-XAZone
#List load for all servers in the farm	Get-XAServerLoad
#List load for all servers in EMEA zone	Get-XAServer -ZoneName EMEA |Select ServerName |Get-XAServerLoad |Sort -Desc Load
#List all servers reporting problem with license server	Get-XAServer -ZoneName EMEA |Select ServerName |Get-XAServerLoad |where {$_.Load -eq 20000 }|Sort ServerName
#List load per server using WMI query	Get-WmiObject -Namespace root\citrix -Class MetaFrame_Server_LoadLevel |Select ServerName, LoadLevel
How to display all Citrix services	Get-Service |where {$_.Name -match "Citrix" -or $_.DisplayName -match "citrix" } |Sort Status |Format-Table -AutoSize
#List all counter sets	get-counter -listset *
#List all counter sets	get-counter -listset "citrix*"
#Available Citrix counter sets:	Citrix Licensing
#Available Citrix counter sets:	Citrix CPU Utilization Mgmt User
#Available Citrix counter sets:	Citrix IMA Networking
#Available Citrix counter sets:	Citrix MetaFrame Presentation Server
#Available Citrix counter sets:	ICA Session
#List all counter names in the ICA Session counter set	(get-counter -listset "ica session").counter
#List all counter names matching specified criteria	(get-counter -listset "ica session").counter |where {$_ -match "latency" }
#Display counter value for ICA session average latency	Get-Counter -Counter "\ICA Session(*)\Latency - Session Average"
#Display counter value for ICA session average latency	or
#Display counter value for ICA session average latency	$1=(get-counter -listset "ica session").counter |where {$_ -match "session average" }
#Display counter value for ICA session average latency	Get-Counter -Counter $1
#List all sessions with status different than Listening or Connected	Get-XASession |Select SessionId, AccountName, ServerName, State |Where {$_.State -ne "Listening" -and $_.State -ne "Connected"}
#List all session with status Active or Disconnected	Get-XASession |Select SessionId, AccountName, ServerName, State |Where {$_.State -eq "Active" -or $_.State -eq "Disconnected"}
#Count all active sesions	(Get-XASession |where {$_.State -eq "Active" }).count
#Count active session per server in particular zone	Get-XAServer -Zone EMEA |Get-XASession |Where {$_.State -eq "Active" }|Sort ServerName |Group-Object ServerName |Format-Table Name,Count -Auto
#Count all active sessions per particular server	Get-XASession -ServerName Server01 |Where {$_.State -eq "Active" }).Count
#Reset session	Stop-XASession -ServerName Server01 -SessionId 2
#Reset session	Get-XASession |where {$_.accountname -like "*UserABC"} |Stop-XASession
#Disconnect session	Disconnect-XASession -ServerName Server01 -SessionId 3 or Get-XASession |where {$_.accountname -like "*UserABC"} |Disconnect-XASession
#List all processes in particular session	Get-XASessionProcess -ServerName Server01 -SessionId 2 |select ProcessName, ProcessId
#Stop application running process 5304	Stop-XASessionProcess -ServerName xenufrdtc01 -ProcessId 5304
How to list applications published to the worker groups ?	Get-XAWorkerGroup *EMEA* |Select WorkerGroupName |Get-XAApplication |Select DisplayName,ClientFolder,ApplicationType |Out-File -Append c:\app-group.txt
How to list configured users for particular application ?	Get-XAApplicationReport -BrowserName ApplicationABC |select Accounts
How to display basic session details for particular user ?	Get-XASession |Select SessionId, State, BrowserName, AccountName, ServerName |Where {$_.AccountName -like "*UserABC*"}
#List all processes in particular session	Get-XASessionProcess -ServerName Server01 -SessionId 2 |select ProcessName, ProcessId
#Stop application running process 5304	Stop-XASessionProcess -ServerName xenufrdtc01 -ProcessId 5304
#List all drivers from Server01	Get-XAPrinterDriver -SourceServerName Server01 |Select DriverName |Sort DriverName
#List all drivers matching name HP*	Get-XAPrinterDriver -ServerName Server01 |Select DriverName |Where {$_.DriverName -like "HP*"} |Sort DriverName
#List all drivers matching name HP*	Get-XAPrinterDriver -ServerName Server01 |Select DriverName |Where {$_.DriverName -like "HP*v6*"} |Sort DriverName
#List printer drivers in the Auto-Replication-List	Get-XAAutoReplicatedPrinterDriver
#Manual replication	Start-XAPrinterDriverReplication "HP Universal Printing PCL 6 (v6.0.0)" -ServerName Server02,Server03
#Auto replication	Add-XAAutoReplicatedPrinterDriver -ServerName Server01 "HP Universal Printing PCL 6 (v6.0.0)"
	

  

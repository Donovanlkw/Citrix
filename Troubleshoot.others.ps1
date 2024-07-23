get-winevent  -logname "Microsoft-Windows-WMI-Activity/Operational"


#Command to reload perfmon counters :- 
#Rebuilding the counters:-
cd c:\windows\system32
lodctr /R
cd c:\windows\sysWOW64
lodctr /R
#Resyncing the counters with Windows Management Instrumentation (WMI):-
WINMGMT.EXE /RESYNCPERF



1. Run Wbemtest
2. In Windows Management Instrumentation Tester, click Connect.
3. In the Namespace box, type root\cimv2, and the click Connect.

4Click Enum Classes.

In the Enter superclass name box, type Win32_Perf, click Recursive and then click OK.

In Query Results, you will not see results for the counters that are not transferred to WMI.

For example, the counter object for Remote Process Explorer is Win32_PerfFormattedData_PerfProc_Process. If this counter does not exist, you will not see the following line in Query Results - Win32_PerfFormattedData_PerfProc_Process.

To Manually reset the WMI counters:

Click Start , click Run, type cmd, and then click OK.
Stop the Windows Management Instrumentation service or at the command prompt, type net stop winmgmt, and then press ENTER.
At the command prompt, type winmgmt /resyncperf, and then press ENTER.
At the command prompt, type wmiadap.exe /f, and then press ENTER.
Start the Windows Management Instrumentation service or at the command prompt, type net start winmgmt, and then press ENTER.
Type exit, and then press ENTER to close the command prompt.
After resetting the WMI counters, retest WMI.
You could also try restarting the Windows  Management Instrumentation Service and check if that works.

* Strong recommendation is that you run the antivirus scan for the all systems, sometimes virus attacks may also indicate a WMIPRVSE high CPU utilization.



https://discussions.citrix.com/topic/395518-wmiprvse-high-cpu-utilization/
https://support.citrix.com/article/CTX223754/xd-712-wmiprvseexe-consumes-high-cpu
https://www.optimizationcore.com/system-administration/complete-wmi-query-guide-wmiexplorer-powershell-cmd/
https://appuals.com/wmi-provider-host-wmiprvse-exe-high-cpu-usage-on-windows-10/





<#

Get-Item C:\ProgramData\CitrixCseCache\*
Get-Item C:\Windows\System32\GroupPolicy\*

\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies

(Get-Item C:\Windows\System32\GroupPolicy).LastAccessTime

C:\Windows\System32\GroupPolicy\Machine
C:\Windows\System32\GroupPolicy\User

###---   https://support.citrix.com/article/CTX134961/citrix-virtual-apps-and-desktops-cvad-policies-are-not-applying-correctly

Get-Item C:\ProgramData\CitrixCseCache\*
Get-Item \HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies

# basic information verification , Resolve DNS

# basic connectivitity check, test-netconnection.
# Get the error log. 


$cmd=Get-Module Citrix.* -ListAvailable | Select-Object Name -Unique
Get-Command -module Citrix.Configuration.Commands    

$CtxCC=Get-ConfigEdgeServer 
$CtxCC |select ZoneName, MachineAddress , LastStateChangeTimeInUtc, IsHealthy
$CtxCC =(Get-ConfigZone).name

###--- create a server list --- ###
$CtxXA=Get-brokermachine -Sessionsupport  MultiSession
$CtxXD=get-brokermachine -MaxRecordCount 99999 -RegistrationState Unregistered -PowerState On |where{{$_.IsAssigned -eq "True"} -and {$_.InMaintenanceMode -eq 'False'}}
$CtxCC=get-ConfigEdgeServer




### Privilege Account
### Troubleshooting for Larger scale outage. 
### test the network connectivity on Netscaler from External / Internal

#Test-FasCertificateSigningRequest — Cmdlet to perform a test certificate signing request (CSR)
#Test-FasCrypto — Cmdlet to perform a test signature operation by signing a piece of data using a test private key
#Test-FasKeyPairCreation — Cmdlet to verify if key pair creation is working
#Test-FasUserCertificateCrypto — Cmdlet to verify whether cryptography is working for a particular user certificate


#>


































$connectTestResult = Test-NetConnection -ComputerName globomantics456.file.core.windows.net -Port 445
if ($connectTestResult.TcpTestSucceeded) {
    # Save the password so the drive will persist on reboot
    cmd.exe /C "cmdkey /add:`"globomantics456.file.core.windows.net`" /user:`"localhost\globomantics456`" /pass:`"xf/FuUtLURgSL4KwJFiQbPzc6j0W+TW4HEo3pST3Ri6KIAk3rOW2k8m3eIHCbQroyXOKFziyY+Nk+ASt/JRdMA==`""
    # Mount the drive
    New-PSDrive -Name Z -PSProvider FileSystem -Root "\\globomantics456.file.core.windows.net\fs123456" -Persist
} else {
    Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
}




#################################################
###=============== DNS enquiry ===============###
Powercfg /systempowerreport

# ----- Query local security policy 

secedit /export /cfg c:\tmp\secpolori.inf
type c:\tmp\secpolori.inf |findstr Lockout

Get-WMIObject -Class Win32_Service -Filter  "Name='MSSQLSERVER'" |   Select-Object Name, DisplayName, StartMode, Status 

(get-acl c:\tmp).access | ft IdentityReference,FileSystemRights,AccessControlType,IsInherited,InheritanceFlags -auto


function Get-Permissions ($folder) {
  (get-acl $folder).access | select `
		@{Label="Identity";Expression={$_.IdentityReference}}, `
		@{Label="Right";Expression={$_.FileSystemRights}}, `
		@{Label="Access";Expression={$_.AccessControlType}}, `
		@{Label="Inherited";Expression={$_.IsInherited}}, `
		@{Label="Inheritance Flags";Expression={$_.InheritanceFlags}}, `
		@{Label="Propagation Flags";Expression={$_.PropagationFlags}} | ft -auto
		}

Get-Permissions -folder "C:\tmp"

(get-acl c:\tmp).access | ft IdentityReference,FileSystemRights,AccessControlType,IsInherited,InheritanceFlags -auto


(get-acl "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server 2016 Redist").access


#################################################
###============SQL Troubleshooting============###
SELECT 'TCP Port' as tcpPort, value_name, value_data 
FROM sys.dm_server_registry 
WHERE registry_key LIKE '%IPALL' AND value_name in ('TcpPort','TcpDynamicPorts')



$File =  "c:\tmp\$env:COMPUTERNAME.txt"
New-Item $file -force
Add-Content $file '$ServerName="' -NoNewline
Add-Content $file "$env:COMPUTERNAME" -NoNewline
Add-Content $file '"'

#----- Capture system information.
cd c:\tmp\
GPresult /H GPresult.html
Get-hotfix |Out-File -FilePath  $file -append -Encoding ascii
systeminfo |Out-File -FilePath  $file -append -Encoding ascii


#----- Enquiry local Password Policy
Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters\" |Out-File -FilePath  $file -append -Encoding ascii

#----- Enquiry Local Secuirty policy
secedit /export /cfg c:secpolori.inf
type c:secpolori.inf |Out-File -FilePath  $file -append -Encoding ascii


#-----Enquiry Permission of Folder
(get-acl c:\tmp).access | ft IdentityReference,FileSystemRights,AccessControlType,IsInherited,InheritanceFlags -auto |Out-File -FilePath  $file -append -Encoding ascii

#----- Enquiry Permission of Registry Key
(get-acl "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server 2016 Redist").access | ft IdentityReference,FileSystemRights,AccessControlType,IsInherited,InheritanceFlags -auto  |Out-File -FilePath  $file -append -Encoding ascii

#----- Enquiry Volume information
get-volume  |Out-File -FilePath  $file -append -Encoding ascii

#----- Enquiry Auto start Windows service.
get-service | select DisplayName, ServiceName, StartType,Status  |findstr Automatic  |Out-File -FilePath  $file -append -Encoding ascii

#----- Enquiry particular Windows service details.
get-service -displayname "SQL*"  | select DisplayName, ServiceName, StartType,Status  |Out-File -FilePath  $file -append -Encoding ascii

#----- Enquiry particular Windows service details.
Get-WMIObject -Class Win32_Service -Filter  "Name='MSSQLSERVER'" |   Select-Object Name, DisplayName, StartMode, Status, StartName  |Out-File -FilePath  $file -append -Encoding ascii

Get-NetAdapter  |Out-File -FilePath  $file -append -Encoding ascii
Get-CimInstance Win32_OperatingSystem | Select-Object  Caption, InstallDate, ServicePackMajorVersion, OSArchitecture, BootDevice,  BuildNumber, CSName | FL



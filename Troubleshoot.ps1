$ComputerName =  ""

$AllCR= $ComputerName |ForEach {
###----- Collect last changed KB/ SW -----# 
(Get-HotFix -ComputerName  $_ | Sort-Object InstalledOn|select InstalledOn, CSName, HotfixID)[-1] |ft

$SW=Get-CimInstance -ComputerName $_ -Class Win32_Product
($SW |Sort-Object InstallDate |select InstallDate, Name , Vendor,  Version)[-1] |ft

###----- Collect last reboot time. -----# 
$SystemInfo =Get-CimInstance  -ComputerName $_ -Class win32_operatingsystem
$SystemInfo |select lastbootuptime  |ft


###--- select all non-started Citrix service --- ###

}
$AllCR


#----- Collect all log from server group in last 1 days-----# 
$StartTime=(Get-date).AddDays(-1)
$EndTime= Get-date

$Error=$ComputerName |foreach {
Get-WinEvent -ComputerName $_ -FilterHashTable @{level=2;LogName="system";StartTime=$StartTime;EndTime=$EndTime}
Get-WinEvent -ComputerName $_ -FilterHashTable @{level=2;LogName="application";StartTime=$StartTime;EndTime=$EndTime}
}

$Error |select timecreated, MachineName, Message |sort timecreated




### --- --- ###



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


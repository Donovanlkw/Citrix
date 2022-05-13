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


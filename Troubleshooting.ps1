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

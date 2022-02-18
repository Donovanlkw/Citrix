
$File =  "c:\temp\$env:COMPUTERNAME.txt"
 
New-Item $file -force

Add-content $file  '#----- Enquiry 2-2 session'
Add-content $file  '
get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters\" |Out-File -FilePath  $file -append -Encoding ascii
'
get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters\" |Out-File -FilePath  $file -append -Encoding ascii


Add-content $file  '#----- Enquiry 2-3 session
secedit /export /cfg c:\temp\secpolori.inf
type c:\temp\secpolori.inf |findstr Lockout  |Out-File -FilePath  $file -append -Encoding ascii
'
secedit /export /cfg c:\temp\secpolori.inf
type c:\temp\secpolori.inf |findstr Lockout  |Out-File -FilePath  $file -append -Encoding ascii


Add-content $file  '#----- Enquiry 2-5 session
Get-WMIObject -Class Win32_Service -Filter  "Name='MSSQLSERVER'" |   Select-Object Name, DisplayName, StartMode, Status, StartName  |Out-File -FilePath  $file -append -Encoding ascii
'
Get-WMIObject -Class Win32_Service -Filter  "Name='MSSQLSERVER'" |   Select-Object Name, DisplayName, StartMode, Status, StartName  |Out-File -FilePath  $file -append -Encoding ascii


Add-content $file  '#----- Enquiry 3 session
get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters\"  |Out-File -FilePath  $file -append -Encoding ascii
'
get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters\"  |Out-File -FilePath  $file -append -Encoding ascii

Add-content $file  '#----- Enquiry 4-1-1 session
(get-acl c:\temp).access | ft IdentityReference,FileSystemRights,AccessControlType,IsInherited,InheritanceFlags -auto |Out-File -FilePath  $file -append -Encoding ascii
'
(get-acl c:\temp).access | ft IdentityReference,FileSystemRights,AccessControlType,IsInherited,InheritanceFlags -auto |Out-File -FilePath  $file -append -Encoding ascii

Add-content $file  '#----- Enquiry 4-1-2 session
get-volume  |Out-File -FilePath  $file -append -Encoding ascii
'
get-volume  |Out-File -FilePath  $file -append -Encoding ascii


Add-content $file  '#----- Enquiry 4-1-3 session
(get-acl "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server 2016 Redist").access | ft IdentityReference,FileSystemRights,AccessControlType,IsInherited,InheritanceFlags -auto  |Out-File -FilePath  $file -append -Encoding ascii

'
(get-acl "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server 2016 Redist").access | ft IdentityReference,FileSystemRights,AccessControlType,IsInherited,InheritanceFlags -auto  |Out-File -FilePath  $file -append -Encoding ascii
 

Add-content $file  '#----- Enquiry 5-5 session
get-service -displayname "Distributed Transaction Coordinator" | select DisplayName, ServiceName, StartType,Status  |Out-File -FilePath  $file -append -Encoding ascii
get-service -displayname "SQL*"  | select DisplayName, ServiceName, StartType,Status  |Out-File -FilePath  $file -append -Encoding ascii
'

get-service -displayname "Distributed Transaction Coordinator" | select DisplayName, ServiceName, StartType,Status  |Out-File -FilePath  $file -append -Encoding ascii
get-service -displayname "SQL*"  | select DisplayName, ServiceName, StartType,Status  |Out-File -FilePath  $file -append -Encoding ascii



Add-content $file  '#----- Enquiry 8-1 session
secedit /export /cfg c:\temp\secpolori.inf
type c:\temp\secpolori.inf |findstr LegalNoticeText  |Out-File -FilePath  $file -append -Encoding ascii
'

secedit /export /cfg c:\temp\secpolori.inf
type c:\temp\secpolori.inf |findstr LegalNoticeText  |Out-File -FilePath  $file -append -Encoding ascii



Add-content $file  '#----- Enquiry 8-3 session
get-service | select DisplayName, ServiceName, StartType,Status  |findstr Automatic  |Out-File -FilePath  $file -append -Encoding ascii

'
get-service | select DisplayName, ServiceName, StartType,Status  |findstr Automatic  |Out-File -FilePath  $file -append -Encoding ascii


Add-content $file  '#----- Enquiry 8-5 session
 Get-NetAdapter  |Out-File -FilePath  $file -append -Encoding ascii

'
 Get-NetAdapter  |Out-File -FilePath  $file -append -Encoding ascii

Add-content $file  '#----- Enquiry 8-6, 8-7 session
get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters"  |Out-File -FilePath  $file -append -Encoding ascii
'
get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters"  |Out-File -FilePath  $file -append -Encoding ascii





dir "C:\Program Files\Microsoft SQL Server\140\Setup Bootstrap\Log"  |Out-File -FilePath  $file -append -Encoding ascii


Get-Content -Path "c:\TEMP\$file.TXT"

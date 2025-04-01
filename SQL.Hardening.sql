
SELECT name, hasdbaccess
FROM sys.sysusers
WHERE name = 'guest'

select name,is_disabled
from sys.server_principals
where type not in ('C','R')
order by name



SELECT *
FROM sys.server_principals 
WHERE TYPE = 'S'

SELECT name
FROM sys.server_principals


SELECT * FROM sys.sql_logins where PWDCOMPARE('',password_hash)=1

SELECT sys.server_role_members.role_principal_id, role.name AS RoleName,   
    sys.server_role_members.member_principal_id, member.name AS MemberName  
FROM sys.server_role_members  
JOIN sys.server_principals AS role  
    ON sys.server_role_members.role_principal_id = role.principal_id  
JOIN sys.server_principals AS member  
    ON sys.server_role_members.member_principal_id = member.principal_id





select name,is_disabled
from sys.server_principals
where type not in ('C','R')
order by name


SELECT name
FROM sys.server_principals 
WHERE TYPE = 'S'
and name not like '%##%'


SELECT CASE SERVERPROPERTY('IsIntegratedSecurityOnly')   
WHEN 1 THEN 'Windows Authentication'   
WHEN 0 THEN 'Windows and SQL Server Authentication'   
END as [Authentication Mode] 








select * from sys.databases where source_database_id is null

select permission_name, state_desc, type_desc, U.name, OBJECT_NAME(major_id) 
from sys.database_permissions P 
JOIN sys.tables T ON P.major_id = T.object_id 
JOIN sysusers U ON U.uid = P.grantee_principal_id
where u.name = 'public'



SELECT [name], is_trustworthy_on
FROM master.sys.databases



EXEC sp_configure 'Ole Automation Procedures';  

EXEC sp_configure 'Database Mail XPs';

EXEC sp_configure 'Ad Hoc Distributed Queries'

sp_configure 'Show advanced options',1
go
exec sp_configure




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



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






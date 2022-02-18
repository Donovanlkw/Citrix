sqlcmd -i C:\tmp\DB.sql -o C:\tmp\222.txt -h -1 -s ","


SELECT @@VERSION AS 'SQL Server Version';  
SELECT @@SERVERNAME AS 'Server Name'  
SELECT @@SERVICENAME AS 'Service Name';  

select name as username,
       create_date,
       modify_date,
       type_desc as type,
       authentication_type_desc as authentication_type
from sys.database_principals
where type not in ('A', 'G', 'R', 'X')
      and sid is not null
      and name != 'guest'
order by username

go

SELECT registry_key, value_name, value_data 
FROM sys.dm_server_registry
WHERE registry_key LIKE '%SuperSocketNetLib%'
go



SELECT name
FROM sys.server_principals 
WHERE TYPE = 'S'
and name not like '%##%'

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

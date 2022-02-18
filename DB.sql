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

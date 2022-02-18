#----- Declare variables -----#
$DomainName= "lab.local"
$DomaninNetBIOSName= "LAB"
$DomainDN="DC=LAB,DC=local"
$DomainAdmin = "Administrator"
$SQLServer="SQL"
$SQLServerName =  "SQL.lab.local"
$SqlServiceAccountName= "svc-sql-01$"

#-----@DC, create Managed service Account for SQL server
#To create the KDS root key in a test environment for immediate effectiveness 
$a=Get-Date
$b=$a.AddHours(-10)
Add-KdsRootKey -EffectiveTime $b
New-ADServiceAccount -Name $SqlServiceAccountName -Enabled $true -Description "Managed Service Account for SQL Server" -DisplayName $SqlServiceAccountName -PrincipalsAllowedToRetrieveManagedPassword $SQLServer$ -DNSHostName $SQLServerName
Test-ADServiceAccount $SqlServiceAccountName

#----- Setup SQL server with predefined parameter 
.\setup.exe /Q /IACCEPTSQLSERVERLICENSETERMS /ACTION="install" /SQLCOLLATION=SQL_Latin1_General_CP1_CI_AS /FEATURES=SQL,RS /INSTANCENAME=MSSQLSERVER /SQLSVCACCOUNT="$env:USERDOMAIN\$SqlServiceAccountName" /SQLSYSADMINACCOUNTS="$env:USERDOMAIN\$DomainAdmin"


#$WSUSServerName = "WSUS.lab.local"
#$SCCMServerName =  "SCCM.lab.local"
#$SDKServerName =  "SCCM.lab.local"


#----- Setup SQL for MEM -----#
$Directory= 'D:SRSReportKeys', 'F:MSSQL', 'F:MSSQLTempDB', 'F:MSSQLUserDB', 'G:MSSQL', 'G:MSSQLUserDBLOG', 'G:MSSQLTempDBLogs', 'G:MSSQLBackup'

#----- create folder and Grant SQLservice account full permission
$Directory|foreach-object{
New-Item $_ -Type Directory
$NewAcl = Get-Acl -Path $_
$identity = "$env:USERDOMAIN\$SqlServiceAccountName$"
$fileSystemRights = "FullControl"
$type = "Allow"
$fileSystemAccessRuleArgumentList = $identity, $fileSystemRights, $type
$fileSystemAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $fileSystemAccessRuleArgumentList
$NewAcl.SetAccessRule($fileSystemAccessRule)
Set-Acl -Path $_ -AclObject $NewAcl
}

# /PID="AAAAA-BBBBB-CCCCC-DDDDD-EEEEE" 



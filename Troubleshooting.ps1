$DNSserverIP1= "8.8.8.8"

$dnsserver= $DNSserverIP1, $DNSserverIP2
$destination1="FQND.NS.CTX.com" 

$Dnsserver|foreach-object{   
Resolve-DnsName -Name $destination1 -Server $_ 
} 
##########################################################

Powercfg /systempowerreport


# ----- Networking
netsh trace start capture=yes
netsh trace stop


#----- Troubleshooting
Test-NetConnection -ComputerName "Hostname or IP"
Test-NetConnection "Hostname" -Port #
Test-NetConnection "Hostname" -traceroute
Get-NetIPConfiguration
Resolve-DnsName -Name "Hostname"
Get-NetTCPConnection
Get-DnsClient
Set-DnsClientServer Address
Clear-DnsClientCache

Invoke-Command -ComputerName -ScriptBlock {ipconfig /release}
Invoke-Command -ComputerName -ScriptBlock {ipconfig /renew}
Disable-NetAdapter -Name "Adapter Name"
Enable-NetAdapter -Name "Adapter Name"



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


#----- SQL Troubleshooting

SELECT 'TCP Port' as tcpPort, value_name, value_data 
FROM sys.dm_server_registry 
WHERE registry_key LIKE '%IPALL' AND value_name in ('TcpPort','TcpDynamicPorts')






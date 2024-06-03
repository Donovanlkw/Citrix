### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- 
### --- Searching assigned published App  & Shared Desktop (not dedicated)--- ### 
$PublishApp=$user.memberof|foreach{
Get-BrokerResource -User $user.SamAccountName -Groups $_}
$PublishApp | select name -Unique



### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- 

#Get the ACL for Destkop
Get-BrokerAccessPolicyRule -MaxRecordCount 10000 |select-Object  DesktopGroupName, IncludedUserFilterEnabled  -ExpandProperty IncludedUsers | Format-table DesktopGroupName, IncludedUserFilterEnabled, FullName |out-file DG.csv

#Get the ACL for PusblishDesktop in XenApp
Get-BrokerEntitlementPolicyRule -MaxRecordCount 10000 |select-Object PublishedName, Enabled -ExpandProperty IncludedUsers | Format-table  PublishedName, Enabled, FullName |out-file Desktop.csv

#Get the ACL for ApplicationGroup access
Get-BrokerApplicationGroup -MaxRecordCount 10000 | Select-Object name, UserFilterEnabled, @{l="AssociatedUserNames";e={$_.AssociatedUserNames -join ","}}  |export-csv AG.csv

#Get the ACL for Application access
Get-BrokerApplication -MaxRecordCount 10000 | Select-Object name, UserFilterEnabled, @{l="AssociatedUserNames";e={$_.AssociatedUserNames -join ","}} |export-csv A.csv



### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- 
### --- CTX Search Servers application published from Server --- ###  
$publishAppName = "Chrome"
$Selectedapp=$PublishApp|where {$_.name -match  $publishAppName} | select name, AssociatedDesktopGroupuUids |select -Unique

$computername =Get-BrokerMachine -DesktopGroupUuid $Selectedapp[1].AssociatedDesktopGroupuUids 
$computername =Get-BrokerMachine -DesktopGroupUid 

$computername.dnsname|foreach{
(Get-ADComputer -Identity $_ -Properties *).CanonicalName 
}

### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- 
### --- CTX seach tags in XA/XD VM--- ###
$tags="tagsname"
$XD |select dnsname, desktopgroupname, @{name='tags'; Expression={$_.tags}} |select-string -AllMatches  UK_UDP_Policy

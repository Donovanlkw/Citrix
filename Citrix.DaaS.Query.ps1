### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- 
### --- Searching assigned published app--- ### 
$PublishApp=$user.memberof|foreach{
Get-BrokerResource -User $user.SamAccountName -Groups $_}
$PublishApp | select name -Unique



### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- 
### --- Searching assigned published Desktop--- ### 
$PublishApp=$user.memberof|foreach{
Get-BrokerResource -User $user.SamAccountName -Groups $_}
$PublishApp | select name -Unique







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

### Searching --- ###

### ---  A.D. User UPN and date related items--- ###
$UPN="First.Last@Domain.com"
$user=Get-ADUser -Filter{UserPrincipalName -eq $UPN} -Properties *
$user |select *date

$userid="userid"
$user=GET-ADuser $userid -Properties * 




$userid="ABC"
$user=GET-ADuser $userid -Properties * 


### --- Searching --- ### 

$PublishApp=$user.memberof|foreach{
Get-BrokerResource -User $user.SamAccountName -Groups $_}

$PublishApp | select name -Unique


### --- CTX Search Servers application published from Server --- ###  
$publishAppName = "Chrome"
$Selectedapp=$PublishApp|where {$_.name -match  $publishAppName} | select name, AssociatedDesktopGroupuUids |select -Unique

$computername =Get-BrokerMachine -DesktopGroupUuid $Selectedapp[1].AssociatedDesktopGroupuUids 
$computername =Get-BrokerMachine -DesktopGroupUid 

$computername.dnsname|foreach{
(Get-ADComputer -Identity $_ -Properties *).CanonicalName 
}


### --- CTX seach tags in XA/XD VM--- ###
$tags="tagsname"
$XD |select dnsname, desktopgroupname, @{name='tags'; Expression={$_.tags}} |select-string -AllMatches  UK_UDP_Policy


### --- A.D. Computer --- ###

$CtxLIC=Get-ADComputer -Filter {Name -like "*00770*" } -Properties * 

### --- get the OU of the computer --- ###

DistinguishedName

### --- search computer based on OU --- ###

$SubOU = " OU=PROD,OU=General Citrix Application Servers"
$SearchBase = $SubOU+",OU=Metaframe Application Servers,OU=Terminal Servers,OU=Infrastructure Servers,OU=Servers,DC=corp,DC=troweprice,DC=net"

$computername=Get-ADComputer -filter *  -SearchBase $SearchBase |select name


### --- search computer based on OU --- ###





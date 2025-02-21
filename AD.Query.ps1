### Searching --- ###

### ---  A.D. User UPN and date related items--- ###
$UPN="First.Last@Domain.com"
$User=Get-ADUser -Filter{UserPrincipalName -eq $UPN} -Properties *
$Userid=$user.SamAccountName
$user=GET-ADuser $userid -Properties * 

$User |select *date



### --- search computer based on OU --- ###
$SubOU = " OU=PROD"
$SearchBase = $SubOU+",OU=Servers,DC=corp,DC=Domain,DC=net"

$computername=Get-ADComputer -filter *  -SearchBase $SearchBase |select name


### ---  get the ACL of the computer object --- ###
Get-ADComputer  $computername | Get-ADPrincipalGroupMembership



### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### 
### ---  Lookup computer object details via IP  computer object --- ###
$ip=get-content ip.txt
$dnshostname=($ip | Resolve-DnsName).namehost
$ADhost=$dnshostname |foreach-object {Get-ADComputer -Properties * -filter 'dnshostname -like $_' }
$ADhost |select dnshostname, description

### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### 
### --- update the new server OU and Description as the old one. 
$oriVM = "oldVM"
$computername= "newVM"
$Description = (Get-ADComputer -Identity $oriVM -Properties *).Description
$oriOU = (Get-ADComputer -Identity $oriVM -Properties *).DistinguishedName
$TargetOU = $oriOU.Substring($oriOU.indexof(",")+1)

$computername |Foreach-object {
get-adcomputer $computername|  Move-ADObject -TargetPath $TargetOU 
Set-ADComputer -Identity $_ -Description $Description
}


### ---  get the ACL of the computer object --- ###
Get-ADComputer  $computername | Get-ADPrincipalGroupMembership

### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### 
### ---  Lookup computer object details via IP  computer object --- ###
$ip=get-content ip.txt
$dnshostname=($ip | Resolve-DnsName).namehost
$ADhost=$dnshostname |foreach-object {Get-ADComputer -Properties * -filter 'dnshostname -like $_' }
$ADhost |select dnshostname, description

### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### 

$userid="ABC"
$user=GET-ADuser $userid -Properties * 


### --- Query all with all the user id and Goup member--- ###

$PublishApp=$user.memberof|foreach{
Get-BrokerResource -User $user.SamAccountName -Groups $_}
$PublishApp | select name -Unique





### --- Additional query. 
$publishAppName = "Chrome"
$Selectedapp=$PublishApp|where {$_.name -match  $publishAppName} | select name, AssociatedDesktopGroupuUids |select -Unique

$computername =Get-BrokerMachine -DesktopGroupUuid $Selectedapp[1].AssociatedDesktopGroupuUids 
$computername =Get-BrokerMachine -DesktopGroupUid 

$computername.dnsname|foreach{
(Get-ADComputer -Identity $_ -Properties *).CanonicalName 
}

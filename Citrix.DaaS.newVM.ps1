
$VM=Get-brokermachine -MaxRecordCount 99999 -Sessionsupport  SingleSession -IsPhysical $false 


### --- staging VM is the unassinged VM, and Group together --###
$StagingVM=$VM |where {($_.desktopgroupname -like "Automation Staging*") -and ($_.isAssigned -eq $false)}|select machinename, CatalogName, desktopgroupname, isAssigned | Group-Object CatalogName,desktopgroupname  |sort name
$requirednewVM = $StagingVM |Where-Object {($_.Count -lt 10)} |select @{name='group';expression={$_.group.Machinename}}
$requirednewVM.GROUP

$vmname=$requirednewVM.GROUP

$Prefix=$vmname | Foreach-object {
$_.substring(0,[regex]::Match($_,"\d+$").index)
}
$allPrefix=$Prefix.tolower() |sort |get-unique

$LastVM=$allPrefix|Foreach-object {
$tmpPrefix=$_
$vmset=$vmname |where {$_ -like "*$tmpPrefix*"}
$vmset.tolower() |sort |select -last 1
}
$LastVM



### --- get the the vmname Prefix  --- ###
$VM=Get-brokermachine -MaxRecordCount 99999 -Sessionsupport  SingleSession -IsPhysical $false

$vmname=$vm.machinename
$Prefix=$vmname | Foreach-object {
$_.substring(0,[regex]::Match($_,"\d+$").index)
}
$allPrefix=$Prefix.tolower() |sort |get-unique

# get the latest vm number.
$LastVM=$allPrefix|Foreach-object {
$tmpPrefix=$_
$vmset=$vm.machinename |where {$_ -like "*$tmpPrefix*"}
$vmset.tolower() |sort |select -last 1
}
#



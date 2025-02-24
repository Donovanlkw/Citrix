### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### 
### --- update the new server OU and Description as the old one. 
$oriVM = "oldVM"
$computername= "newVM"

### --- get the AD information
$oriDescription = (Get-ADComputer -Identity $oriVM -Properties *).Description
$oriOU = (Get-ADComputer -Identity $oriVM -Properties *).DistinguishedName
### --- host table
$oriHost = get-content \\$oriVM\c$\Windows\system32\drivers\etc\hosts | Select-String -NotMatch "^#|^$"


### --- applied to new VM
$computername |Foreach-object {
get-adcomputer $computername|  Move-ADObject -TargetPath $TargetOU 
Set-ADComputer -Identity $_ -Description $Description
Add-Content \\$_\c$\Windows\system32\drivers\etc\hosts  $oriHost
}
























### --- localsec, localgpo
$oriSecpol=secedit /export /cfg $env:tmp\orisecpol.inf
$targetcpol=get-content (secedit /export /cfg $env:tmp\orisecpol.inf)

### --- the certification
(Get-childitem -path cert:\localmachine\My |sort NotBefore |select Subject )[-1]
Get-childitem -path cert:\localmachine\Root  |sort NotBefore 
Get-childitem -path cert:\localmachine\CA |sort NotBefore


### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### 
### --- update the new server OU and Description as the old one. 
$oriVM = "oldVM"
$computername= "newVM"

### --- AD information
$oriDescription = (Get-ADComputer -Identity $oriVM -Properties *).Description
$oriOU = (Get-ADComputer -Identity $oriVM -Properties *).DistinguishedName

$computername |Foreach-object {
get-adcomputer $computername|  Move-ADObject -TargetPath $TargetOU 
Set-ADComputer -Identity $_ -Description $Description
}

### --- Windows content
$oriHost = get-content \\$oriVM\c$\Windows\system32\drivers\etc\hosts | Select-String -NotMatch "^#|^$"
# the certification
# the local gpo/ localsec.
# schedule task.



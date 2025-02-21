### --- this is the sample for replace a existing SF server 
$oriVM = "oriVM"
$computername= "newVM"
$Description = (Get-ADComputer -Identity $oriVM -Properties *).Description
$oriOU = (Get-ADComputer -Identity $oriVM -Properties *).DistinguishedName
$TargetOU = $oriOU.Substring($oriOU.indexof(",")+1)

$computername |Foreach-object {
#get-adcomputer $computername|  Move-ADObject -TargetPath $TargetOU 
Move-ADObject -Identity $_ -TargetPath $TargetOU 
Set-ADComputer -Identity $_ -Description $Description
}

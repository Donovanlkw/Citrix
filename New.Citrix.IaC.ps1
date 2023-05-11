### --- create a admin group --- ###
### --- Enable Read-only admin --- ###


$ADGroup= "MFCGD\"
$Role="Read Only Administrator"

New-AdminAdministrator -Name $ADGroup
Add-AdminRight -Role $role  -All -Administrator $ADGroup



### --- Enable Log , but not mandatry --- ###
$logdbconnection=Get-LogDBConnection
set-logsite -state Enabled



https://support.citrix.com/article/CTX208610/citrix-supportability-pack-updater


Import-Module "C:\Citrix_Supportability_Pack\Tools\Scout\Current\Utilities\Citrix.GroupPolicy.Commands.psm1"
Get-Module
Get-command -Module Citrix.GroupPolicy.Commands


###--- Disabled all the default policy ---###
set-ctxgrouppolicy -PolicyName "unfiltered" -type user -Enabled $false
set-ctxgrouppolicy -PolicyName "unfiltered" -type Computer -Enabled $false

set-ctxgrouppolicy -PolicyName "unfiltered" -type user -Enabled $false
set-ctxgrouppolicy -PolicyName "unfiltered" -type Computer -Enabled $false








https://www.linkedin.com/pulse/create-citrix-cvad-policies-powershell-robin-meeuwsen

### --- crate policy --- ###

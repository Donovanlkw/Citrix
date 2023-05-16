New-AdminAdministrator -Name "MFCGD\APP-AZ Asia Citrix-Admin"

### --- Citrix core setup ---###
$ADGroup= "MFCGD\APP-AZ Asia Citrix-Admin"
$Role="Read Only Administrator"

New-AdminAdministrator -Name $ADGroup
Add-AdminRight -Role $role  -All -Administrator $ADGroup

$logdbconnection=Get-LogDBConnection
set-logsite -state Enabled

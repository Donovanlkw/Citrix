### workaround to create reg key in user  HKCU session.

Invoke-Command -Computer $computername -ScriptBlock {
$sids=get-childitem "registry::HKEY_USERS" |where-object {$_.name -match "S-1-5-21-\d+-\d+-\d+-\d+$"}
$sids.name|foreach-Object {
New-ItemProperty "registry::$_\software\citrix\HDXMediaStream\" -Name "MSTeamsRedirSupport" -value "1" -propertytype "DWord"
}
}

$userid = ""
$SID=(get-aduser $userid).sid.value


##---  get the ACL of the computer object ---##
Get-ADComputer  $computername | Get-ADPrincipalGroupMembership

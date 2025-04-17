### Searching --- ###

### ---  A.D. User UPN and date related items--- ###
$UPN="First.Last@Domain.com"
$user=Get-ADUser -Filter{UserPrincipalName -eq $UPN} -Properties *
$user |select *date
$userid=$user.uid

### --- $userid=GET-ADuser $userid -Properties * 
$session=Get-BrokerSession -userupn $upn -SessionState Active 
$session| select machinename, DesktopGroupName, LaunchedViaPublishedName
$session.machinename

### --- get the OU of the computer --- ###
$allOU=$session.machinename|foreach {
$computerName = split-path -path $_ -leaf
$adComptuer=Get-ADComputer $computerName -Properties *
$DN=($ADComptuer).distinguishedname
$findchar = $DN.IndexOf(",")
$OU=$DN.Substring($findchar+1)
#$OU = $DN.Substring($DN.IndexOf(",")+1)
$OU
}

### --- get the GPO of the computer --- ###
$allGPO=$allOU |foreach {
$_
$GPO=Get-GPInheritance -Target $_
    if ($GPO.GpoInheritanceBlocked -eq "true"){
    $GPO.GpoLinks.displayname
    }
    else
    {
    $tmpGPO=$GPO.GpoLinks 
    $tmpGPO+=$GPO.inheritedgpolinks
    $tmpGPO.displayname | sort -Unique
}
}


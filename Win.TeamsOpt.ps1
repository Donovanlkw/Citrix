$DG= ""
$today=Get-Date -f "yyyyMMdd"

###--- query all the DG VDI
$VDI=get-brokerdesktop -DesktopGroupName $DG -MaxRecordCount 99999 -SessionState "active"
$VDI.dnsname |out-file VDIlist_$DG"_"$today.txt


### --- MS Teams optimization validation webScoketAgent  --- ###

$DG= "EMEA"
$today=Get-Date -f "yyyyMMdd"
$ComputerName = Get-Content VDIlist_$DG"_"$today.txt

$TeamsOptState=$ComputerName| Foreach-object {
$TeamsOpt=Get-process -computername $_ -name WebSocketAgent |select Name
Write-Output "$_ + $TeamsOpt"
Write-host "$_ + $TeamsOpt"
}
$TeamsOptState |select-string -AllMatch websocketagent |out-file TeamsOpt_$DG"_"$today.txt
$TeamsOptState.replace(" + ", "")|select-string -NotMatch websocketagent |out-file TeamsOptFailure_$DG"_"$today.txt


### --- MS Teams optimization Troubelshooting in details  --- ###
$ComputerName = Get-Content TeamsOptFailure_$DG"_"$today.txt

$ComputerName| Foreach-object {
Invoke-Command -Computer $_ -ScriptBlock {
Get-ItemProperty -Path "HKLM:SOFTWARE\WOW6432Node\Citrix\WebSocketService"
Get-ItemProperty -Path "HKLM:SOFTWARE\Microsoft\Teams"
#Get-ItemProperty -Path "HKCU:SOFTWARE\Citrix\HDXMediaStream"
Get-Process  -Name web*
get-process -name web* |select PSComputerName,Name, productversion, starttime |ft
get-process -name Teams* |select PSComputerName, Name, productversion, starttime, startinfo |ft
get-process -name ms-Teams* |select startinfo |ft
netstat -na |findstr 9001
}
}

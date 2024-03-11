$DG=""

$today=Get-Date -f "yyyyMMdd"

$Today=Get-Date -f "yyyyMMdd"

$VDI=get-brokersession -MaxRecordCount 99999 -SessionState "active" -Protocol "HDX" -OSType "Windows 10"


###--- query all the DG VDI

$VDI=get-brokersession -MaxRecordCount 99999 -SessionState "active" -Protocol "HDX" -OSType "Windows 10"
$ActiveVDI=$VDI |where Desktopgroup -eq $DG
$ActiveVDI|select UserUPN, DNSName,  BrokeringTime, AgentVersion, ClientPlatform, ClientName, ClientVersion, ConnectedViaIP, SessionState |ft|out-file VDIsession_$DG"_"$today.txt
$ActiveVDI.dnsname |out-file VDIlist_$DG"_"$today.txt


###--- query active Computername by email .
$userlist = Get-Content userlist.txt
$DG=""
$VDI=get-brokersession -MaxRecordCount 99999 -SessionState "active" -Protocol "HDX" -OSType "Windows 10"

$ActiveVDI=$Userlist| Foreach-object {
$VDI |where UserUPN -eq $_ 
}

$ActiveVDI|select UserUPN, DNSName,  BrokeringTime, AgentVersion, ClientPlatform, ClientName, ClientVersion, ConnectedViaIP, SessionState |sort DNSName|ft |out-file VDIsession_$DG"_"$today.txt
$ActiveVDI.dnsname |sort |out-file VDIlist_$DG"_"$today.txt




### --- MS Teams optimization validation webScoketAgent  --- ###
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
#Get-ItemProperty -Path "HKLM:SOFTWARE\Microsoft\Teams"
#Get-ItemProperty -Path "HKCU:SOFTWARE\Citrix\HDXMediaStream"
Get-Process  -Name web*
get-process -name web* |select PSComputerName,Name, productversion, starttime |ft
get-process -name Teams* |select PSComputerName, Name, productversion, starttime, startinfo |ft
get-process -name ms-Teams* |select startinfo |ft
netstat -na |findstr 9002

}
}


###--- query problem 's VDI issue. 

$ComputerName = Get-Content TeamsOptFailure.txt

$TeamsUsers = $ComputerName| Foreach-object {
Get-Brokersession -dnsname $_ |select userupn, BrokeringTime, ClientName, ClientVersion, AgentVersion, SessionState
}

$TeamsUsers |ft 


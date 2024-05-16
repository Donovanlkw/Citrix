### --- Collect Data --- ###
$XA=Get-brokermachine -Sessionsupport  MultiSession
$XD=Get-brokermachine -MaxRecordCount 99999 -Sessionsupport  SingleSession
$ICA=Get-BrokerSession -MaxRecordCount 99999 -MachineSummaryState Inuse
$CC=Get-ConfigEdgeServer 
$DG=get-brokerdesktopgroup


### --- for Particular userlist HDXTeamsOpt
### --- query Active VDI which match the userlist(email)
$userlist = Get-Content userlist.txt
$ActiveVDI=$Userlist| Foreach-object {
    $ICA |where UserUPN -eq $_ 
}

###--- Generate Report.
$ActiveVDI|select UserUPN, DNSName, ClientPlatform, ClientName, ClientVersion |sort DNSName|ft |out-file VDIsession_$today.txt
$ActiveVDI.dnsname |sort |out-file VDIlist_$today.txt


###--- Optional to identifed connected VDI only 
$VM=get-content VDIlist_$today.txt
$VDI=$VM| Foreach-object {
    $ICA |where dnsname -eq $_ 
}
$VDI.dnsname |sort |out-file VDIlistconnected_$today.txt

### --- assume picashell = connected device   --- ###
$ComputerName = Get-Content VDIlist_$today.txt

$TeamsOptState = $ComputerName| Foreach-object {
Write-HOST $_
    $process=Get-process -computername $_
    if($process.name -match "picashell") {

        if(!($process.name -match "WebSocketAgent")) {
            if($process.name -match "teams") {
		    Write-Output $_
        Write-host $_
            }
        }
        if($process.name -match "WebSocketAgent") {
		    Write-Output $_"_TeamsOpt"
        Write-host $_"_TeamsOpt"
        }
}
}
#$TeamsOptState |out-file ./"-NotHDXOpt_"$Today.txt
($TeamsOptState |select-string -AllMatch TeamsOpt ) -replace("_TeamsOpt", "")|out-file "TeamsOpt_$today.txt"
$TeamsOptState |select-string -NotMatch TeamsOpt |out-file "TeamsOptFailure_$today.txt"

### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###  

### --- MS Teams optimization Troubelshooting in details  --- ###
$ComputerName = Get-Content "TeamsOptFailure_$today.txt"

$ComputerName| Foreach-object {
Invoke-Command -Computer $_ -ScriptBlock {
Write-host "$env:computername"
get-service -displayname "Citrix HDX*"  |select status, Name, Starttype |ft
netstat -na |findstr 9002
get-process |where {($_.name -match "team") -or ($_.name -match "WebSocket") }|select name,starttime,fileversion |sort starttime
Get-WinEvent -FilterHashTable @{LogName="Citrix-HostCore-ICA Service/Operational";Id=25;StartTime=(Get-date).AddDays(-2)}
Get-WinEvent -FilterHashTable @{LogName="Citrix-HostCore-ICA Service/Operational";Id=26;StartTime=(Get-date).AddDays(-2)}
#(Get-CimInstance -Class win32_operatingsystem).lastbootuptime
#Get-process -name Teams |select Modules
#(Get-ItemProperty -Path "HKLM:SOFTWARE\WOW6432Node\Citrix\WebSocketService").Processwhitelist
#(Get-ItemProperty -Path "HKLM:SOFTWARE\Microsoft\Teams").VDIOptimizationMode
#Get-ItemProperty -Path "HKCU:SOFTWARE\Citrix\HDXMediaStream"
#$x.Modules |ft |sort filename
}
}

### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###  
### --- MS Teams optimization Troubelshooting in Client version/platform  --- ###
$ComputerName = Get-Content "TeamsOptFailure_$today.txt"

$ClientSupport = $ComputerName| Foreach-object {
$ICA |where{{$_.dnsname -eq $_ } 
}
$ClientSupport   |select userupn, Clientplatform, ClientVersion, AgentVersion

### --- query Active VDI which match the userlist(email)  --- ###
$userlist = Get-Content userlist.txt
$VDI=$Userlist| Foreach-object {
    $XD |where AssociatedUserUPNs -eq $_ 
}

###--- Generate Report.
$VDI|select UserUPN, DNSName, DesktopGroupName, BrokeringTime, AgentVersion, ClientPlatform, ClientName, ClientVersion, ConnectedViaIP, SessionState |sort DNSName|ft |out-file VDIsession_$today.txt
$VDI.dnsname |sort |out-file VDIlist_$today.txt




### --- MS Teams optimization Troubelshooting in details  --- ###
$ComputerName = Get-Content "TeamsOptFailure_$today.txt"
$UPN=$ComputerName | Foreach-object {
    $XD |where dnsname -eq $_ 
}

$UPN.AssociatedUserUPNs | out-file  "TeamsOptFailureUserlist_$today.txt"






### --- Others  --- ###

$DGFileName=(Get-ChildItem).Name
$DGFileName | Foreach-object {
Write-HOST $_
$ComputerName = Get-Content "$_"
$HDXOpt = $ComputerName| Foreach-object {
Write-HOST $_
    $process=Get-process -computername $_
    if($process.name -match "picashell") {

        if(!($process.name -match "WebSocketAgent")) {
            if($process.name -match "teams") {
		Write-Output $_"_NoHDXOpt"
        Write-host $_"_NoHDXOpt"
            }
        }
        if($process.name -match "WebSocketAgent") {
		Write-Output $_"_HDXOpt"
        Write-host $_"_HDXOpt"
        }
}
}
$HDXOpt |out-file ./$_"-NotHDXOpt_"$Today.txt
}






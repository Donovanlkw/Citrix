$DG=""
$Today=Get-Date -f "yyyyMMdd"
$XD=get-brokersession -MaxRecordCount 99999 -SessionState "active" -Protocol "HDX" -OSType "Windows 10"



$userlist = Get-Content userlist.txt


    ###--- query Active VDI in particular DG
    $ActiveVDI=$XD |where Desktopgroup -eq $DG*


    ###--- query Active VDI which match the userlist(email)
    $userlist = Get-Content userlist.txt
    $ActiveVDI=$Userlist| Foreach-object {
    $XD |where UserUPN -eq $_ 
    }

###--- Generate Report.

$ActiveVDI|select UserUPN, DNSName, DesktopGroupName, BrokeringTime, AgentVersion, ClientPlatform, ClientName, ClientVersion, ConnectedViaIP, SessionState |sort DNSName|ft |out-file VDIsession_$DG"_"$today.txt
$ActiveVDI.dnsname |sort |out-file "VDIlist_$DG_$today.txt"

#########################################################################################################


### --- MS Teams optimization validation webScoketAgent  --- ###
$ComputerName = Get-Content  "VDIlist_$DG_$today.txt"

$TeamsOptState=$ComputerName| Foreach-object {
$TeamsOpt=Get-process -computername $_ -name WebSocketAgent |select Name
Write-Output "$_ + $TeamsOpt"
Write-host "$_ + $TeamsOpt"
}
$TeamsOptState |select-string -AllMatch websocketagent |out-file "TeamsOpt_$DG_$today.txt"
$TeamsOptState.replace(" + ", "")|select-string -NotMatch websocketagent |out-file "TeamsOptFailure_$DG_$today.txt"


#########################################################################################################


### --- MS Teams runnin in VDI mode ?  --- ###
$ComputerName = Get-Content "TeamsOptFailure_$DG_$today.txt"
$TeamsVDIMode=$ComputerName| Foreach-object {
$TeamsVDI=((Get-process -computername $_ -name ms-teams).modules).filename |select-string -AllMatche SlimCore
Write-Output "$_ + $TeamsVDI"
Write-host "$_ + $TeamsOpt"
}
$TeamsVDIMode


#$TeamsOptState |select-string -AllMatch websocketagent |out-file "TeamsOpt_$DG_$today.txt"
#$TeamsOptState.replace(" + ", "")|select-string -NotMatch websocketagent |out-file "TeamsOptFailure_$DG_$today.txt"

### --- MS Teams optimization Troubelshooting in Level 2, check the starttime of Ms-Teams, --- ###
$ComputerName = Get-Content "TeamsOptFailure_$DG_$today.txt"

$TeamsStartupTime=$ComputerName| Foreach-object {
Invoke-Command -Computer $_ -ScriptBlock {
get-process -name ms-Teams |select starttime 
}
}
$TeamsStartupTime|sort Starttime|out-file "TeamsStartupTime_$DG_$today.txt"



### --- MS Teams optimization Troubelshooting in details  --- ###
$ComputerName = Get-Content "TeamsOptFailure_$DG_$today.txt"

$ComputerName| Foreach-object {
Invoke-Command -Computer $_ -ScriptBlock {
Write-host "$env:computername"
get-service -displayname "Citrix HDX*"  |select status, Name, Starttype |ft
netstat -na |findstr 9002
#(Get-ItemProperty -Path "HKLM:SOFTWARE\WOW6432Node\Citrix\WebSocketService").Processwhitelist
#(Get-ItemProperty -Path "HKLM:SOFTWARE\Microsoft\Teams").VDIOptimizationMode
#Get-ItemProperty -Path "HKCU:SOFTWARE\Citrix\HDXMediaStream"
get-process -name *Teams |select name,starttime,fileversion |ft
get-process -name WebSocket*|select name,starttime,fileversion |ft
(Get-CimInstance -Class win32_operatingsystem).lastbootuptime
#Get-process -name Teams |select Modules
#$x.Modules |ft |sort filename
#get-process -name web* |select PSComputerName,Name, productversion, starttime |ft
#get-process -name Teams* |select PSComputerName, Name, productversion, starttime, startinfo |ft
#get-process -name ms-Teams* |select startinfo |ft
}
}

### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### 
### ### ### --- verify Teams Opt all VM in DG --- ### ###  ###

### --- Get the full list of VM Per DG (CTX Admin)--- ###
$DGName=$DG |where {`
($_.SessionSupport -eq "SingleSession") -and `
($_.Enabled -eq "True")
} |select Name

$DGName | Foreach-object {
$currentDG=$_.name
Write-output $currentDG
($XD |where {($_.IsAssigned -eq "True") -and ($_.Desktopgroupname -eq $currentDG) }).dnsname |out-file ./$CurrentDG.txt
}

### --- Get the full list of VM Per DG (Local Admin) --- ###
$DGFileName=(Get-ChildItem).Name
$DGFileName | Foreach-object {
Write-output $_
$ComputerName = Get-Content "$_"

$NoHDXOpt=$ComputerName| Foreach-object {
    Invoke-Command -Computer $_ -ScriptBlock {
    #ctxsession
    #Get-process -name WebSocketAgent
        if (ctxsession){
        #if CTX connected, run the next command
            if (!(Get-process -name WebSocketAgent)) {
            #if WebScoketAgent is NOT existing, write down the hostname
                if (Get-process -name *teams*) {
                #if WebScoketAgent is NOT existing, write down the hostname
                     Write-Output $env:computername
                    }
                }
            }
        }
    }
$NoHDXOpt |out-file ./$_"-NotHDXOpt_"$Today.txt
}
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### 



























###--- query problem 's VDI issue. 

$ComputerName = Get-Content EMEATeamsOptFailure.txt

$TeamsUsers = $ComputerName| Foreach-object {
Get-Brokersession -dnsname $_ |select userupn, BrokeringTime, ClientName, ClientVersion, AgentVersion, SessionState
}

$TeamsUsers |ft 




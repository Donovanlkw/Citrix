### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- 
### ---  From End point to to Web --- ###
$FQDN=
"www.yahoo.com.hk"

$IP=
"76.223.84.192"
$Result_EP2Web=$FQDN |ForEach-Object {
Test-NetConnection $_ -port 443 
}
$Result_EP2Web | Select ComputerName, tcptestsucceeded, RemoteAddress

Compare-object -ReferenceObject $IP -DifferenceObject $Result.RemoteAddress.IPAddressToString -IncludeEqual

### ---  From Performance Endpoint to to Web --- ###
$performance=$FQDN |ForEach-Object {
Measure-Command { Test-NetConnection $_ -port 443}
}
$Performance. totalseconds 


### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- ### --- 

### ---  From SF to DDC --- ###
$Result_SF2CC= Invoke-Command -computer  $CtxSF -ScriptBlock {
$Using:ctxccc |ForEach-Object {
Test-netconnection $_ -port 80
    }
}
$Result_SF2CC |select pscomputername, computername, remoteaddress, tcptestsucceeded, remoteport |ft

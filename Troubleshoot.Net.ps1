#################################################
###======== Identify the tcp port opened by process ======###
$processname= "telegraf"
get-nettcpconnection |Where-Object {$_.OwningProcess -eq (get-process -name "$processname").Id}











#################################################
###=============== Network performance ===============###
$RESULT = import-csv PIP.txt -Header PIP
$RESULT|
Foreach-object{
$Perf=Measure-command {test-netconnection $_.pip -port 443 -InformationLevel Quiet } |% TotalMilliseconds
$_ | Add-Member -MemberType NoteProperty -Name 'Performance' -Value $Perf 
}
$RESULT


#################################################
###=============== DNS enquiry ===============###
#$DNSIP= "8.8.8.8"
$DNSIP= Get-Content DNSIP.txt
$FQDN1="z.z.z.z"
$FQDN2="x.x.x"
$DNSIP|foreach-object{   
Resolve-DnsName -Name $FQDN1 -Server $_
Resolve-DnsName -Name $FQDN2 -Server $_
} 


#################################################
###=============== Network tracing ===========###
netsh trace start capture=yes
netsh trace stop
Test-NetConnection -ComputerName "Hostname or IP"
Test-NetConnection "Hostname" -Port #
Test-NetConnection "Hostname" -traceroute
Get-NetIPConfiguration
Resolve-DnsName -Name "Hostname"
Get-NetTCPConnection
Get-DnsClient
Set-DnsClientServer Address
Clear-DnsClientCache


#################################################
###=============== NIC control ===============###
Disable-NetAdapter -Name "Adapter Name"
Enable-NetAdapter -Name "Adapter Name"

Get-NetAdapter  |Out-File -FilePath  $file -append -Encoding ascii


### ---
# https://devblogs.microsoft.com/scripting/packet-sniffing-with-powershell-getting-started/

(gcm -Module NetEventPacketCapture | measure).count
 gcm -Module NetEventPacketCapture | select name

# Add a new network event session with 
New-NetEventSession.
#Add a network event provider to the session with 
New-NetEventProvider.
#Start the session with 
Start-NetEventSession.
#Get information about the session with Get-NetEventSession.
#Stop the network event session with Stop-NetEventSession.
#Remove the network event session with Remove-NetEventSession.



New-NetEventSession -Name “Session1”






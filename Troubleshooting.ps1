$DNSserverIP1= "8.8.8.8"

$dnsserver= $DNSserverIP1, $DNSserverIP2
$destination1="FQND.NS.CTX.com" 

$Dnsserver|foreach-object{   
Resolve-DnsName -Name $destination1 -Server $_ 
} 
##########################################################

Powercfg /systempowerreport


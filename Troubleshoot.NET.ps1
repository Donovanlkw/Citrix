@


measure-command {test-netconnection @IP -port 443 } |% TotalMilliseco



$FQDN1="asiacitrix.manulife.com"
$FQDN2="citrix.manulife.com"

$DNSIP|foreach-object{   
#Resolve-DnsName -Name $FQDN1 -Server $_
Resolve-DnsName -Name $FQDN2 -Server $_
} 

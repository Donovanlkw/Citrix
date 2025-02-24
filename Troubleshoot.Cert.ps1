### --- check the cerification of URL --- ###

$url = "https://citrix.cloud.com"

#Perform a web request to get the certificate
$request = [System.Net.HttpWebRequest]::Create($url)
$request.AllowAutoRedirect = $false
$request.Method = "HEAD"
$response = $request.GetResponse()

#Get the SSL certificate
$cert = $request.ServicePoint.Certificate
$cert2 = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 $cert

#Display certificate details
"Subject: $($cert2.Subject)"
"Issuer: $($cert2.Issuer)"
"Effective Date: $($cert2.NotBefore)"
"Expiry Date: $($cert2.NotAfter)"
"Thumbprint: $($cert2.Thumbprint)"


### --- check the certification support portocol --- ###
Get-ItemProperty -Path "HKLM:SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols"


### --- searching the certification of local store.--- ###

# check the certification protocol
$x=[Net.ServicePointManager]::Securityprotocol

# configure multi certification protocol
#[Net.ServicePointManager]::Securityprotocol = [Net.ServicePointManager]::Securityprotocol::Ssl3 -bor  [Net.ServicePointManager]::Securityprotocol::Tls -bor   [Net.ServicePointManager]::Securityprotocol::Tls12 

HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols


### --- searching the certification of local store.--- ###
Get-childitem -path cert:\localmachine\My
Get-childitem -path cert:\localmachine\Root
Get-childitem -path cert:\CurrentUser\My

### --- searching the certification of local store.--- ###
Get-childitem -path cert:\localmachine\My |where{$_.subject -like "*keyword*"}

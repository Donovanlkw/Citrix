# Get Access Token
$body = @{
    client_id     = $ClientId
    client_secret = $ClientSecret
    grant_type    = "client_credentials"
}

$tokenResponse = Invoke-RestMethod -Uri "https://api-us.cloud.com/cctrustoauth2/root/tokens/clients" -Method Post -Body $body
$AccessToken = $tokenResponse.access_token
$token =  "CwsAuth Bearer=" + $AccessToken

$headers = @{
    "Authorization" = $token
    "Citrix-CustomerId" = $CustomerId
}

$CCCCURL= 
        "citrix.cloud.com",
        "ap-s.cloud.com",
        "us.cloud.com",
        "eu.cloud.com",
        "accounts.cloud.com",
        "www.microsoft.com",
        "www.google.com",
        "trowepriceas.sharefile.com",
        "agenthub.citrixworkspacesapi.net/$customerID/ping",
        "agenthub-ap-s.citrixworkspacesapi.net/$customerID/ping",
        "agenthub-us.citrixworkspacesapi.net/$customerID/ping",
        "agenthub-eu.citrixworkspacesapi.net/$customerID/ping",
        "trust.citrixworkspacesapi.net/$customerID/ping",
        "trust-ap-s.citrixworkspacesapi.net/$customerID/ping",
        "trust-us.citrixworkspacesapi.net/$customerID/ping",
        "trust-eu.citrixworkspacesapi.net/$customerID/ping",
        "registry.citrixworkspacesapi.net/$customerID/ping",
        "registry-ap-s.citrixworkspacesapi.net/$customerID/ping",
        "registry-us.citrixworkspacesapi.net/$customerID/ping",
        "registry-eu.citrixworkspacesapi.net/$customerID/ping",
        "cws.citrixworkspacesapi.net/$customerID/ping",
        "cws-ap-s.citrixworkspacesapi.net/$customerID/ping",
        "cws-us.citrixworkspacesapi.net/$customerID/ping",
        "cws-eu.citrixworkspacesapi.net/$customerID/ping",
        "core.citrixworkspacesapi.net/$customerID/Ping",
        "core-ap-s.citrixworkspacesapi.net/$customerID/Ping",
        "core-us.citrixworkspacesapi.net/$customerID/Ping",
        "core-eu.citrixworkspacesapi.net/$customerID/Ping",
        "identity.citrixworkspacesapi.net/$customerID/ping",
        "identity.citrixworkspacesapi.net/$customerID/ping",
        "identity.citrixworkspacesapi.net/$customerID/ping",
        "identity.citrixworkspacesapi.net/$customerID/ping",
        "ticketing.citrixworkspacesapi.net/$customerID/ping",
        "ticketing-ap-s.citrixworkspacesapi.net/$customerID/ping",
        "ticketing-us.citrixworkspacesapi.net/$customerID/ping",
        "ticketing-eu.citrixworkspacesapi.net/$customerID/ping",
        "messaging.citrixworkspacesapi.net/$customerID/ping",
        "messaging-ap-s.citrixworkspacesapi.net/$customerID/ping",
        "messaging-us.citrixworkspacesapi.net/$customerID/ping",
        "messaging-eu.citrixworkspacesapi.net/$customerID/ping",
        "credentialwallet.citrixworkspacesapi.net/$customerID/ping",
        "credentialwallet-ap-s.citrixworkspacesapi.net/$customerID/ping",
        "credentialwallet-us.citrixworkspacesapi.net/$customerID/ping",
        "credentialwallet-eu.citrixworkspacesapi.net/$customerID/ping",
        "cwsproduction.blob.core.windows.net/downloads",
        "ccprodaps.blob.core.windows.net",
        "ccprodeu.blob.core.windows.net",
        "ctxwsp-agent-eastus.servicebus.windows.net",
        "ctxwsp-agent-australiaeast.servicebus.windows.net",
        "ctxwsp-agent-westeurope.servicebus.windows.net",
        "www.d-trust.net",
        "cacerts.digicert.com"
        
    
$testresult=$CCCCURL|Foreach-object {
$result=Invoke-WebRequest -Uri $_ 
write-host $result.StatusCode
	[PSCustomObject]@{URL="$_"; Result=$result.StatusCode}
}

### ---  run the validation remotely to CCC --- ### 
$testresult=$CCCCURL|Foreach-object {
$result=Invoke-WebRequest -Uri $_ 
write-host $result.StatusCode
	[PSCustomObject]@{URL="$_"; Result=$result.StatusCode}
}


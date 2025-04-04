### https://developer-docs.citrix.com/en-us/citrix-cloud/citrix-cloud-api-overview/citrix-cloud-api-walkthrough.html
Asnp Citrix*
#Get the authentication profile
Get-XDAuthentication –ProfileName “CloudAdmin”


### --- Store and use Credentials in a Variable on-perm--- ###
$cred = Get-Credential
Set-Item -Path "HKCU:\Software\Citrix\Desktop" -Name "Credential" -Value $cred.UserName  # Store username
Set-Item -Path "HKCU:\Software\Citrix\Desktop" -Name "Password" -Value $cred.GetNetworkCredential().Password  # Store password


# Retrieve Citrix Cloud credentials in variable DaaS --- ###
$citrixCredentials = Get-XDCredentials


### --- Store and use Credentials in a Variable --- ###



###--- Citrix DaaS API ---###
$CLIENT_ID=' '
$CLIENT_SECRET=' '
$customerId = ''

$resourceLocUrl = "https://registry.citrixworkspacesapi.net/$customerId/resourcelocations"
$tokenUrl = 'https://api-us.cloud.com/cctrustoauth2/root/tokens/clients'

### OAuth 2.0 Authentication
$response = Invoke-WebRequest $tokenUrl -Method POST -Body @{
  grant_type = "client_credentials"
  client_id = $CLIENT_ID
  client_secret = $CLIENT_SECRET
}

###--- 
# Define client credentials and endpoint
$clientId = "your-client-id"
$clientSecret = "your-client-secret"
$tenantId = "your-tenant-id"
$authUrl = "https://oauth.cloud.citrix.com/token"

# Prepare the request body
$body = @{
    grant_type    = "client_credentials"
    client_id     = $clientId
    client_secret = $clientSecret
    scope         = "citrix.daas.api"
}

# Send POST request to get the token
$response = Invoke-RestMethod -Uri $authUrl -Method Post -ContentType "application/x-www-form-urlencoded" -Body $body

# Extract the access token from the response
$accessToken = $response.access_token

# Store the access token for subsequent requests
$headers = @{
    "Authorization" = "Bearer $accessToken"
}


###--- 



###--- 










$response
$token = $response.Content | ConvertFrom-Json
$token | Format-List

### --- ### --- ### --- ### --- ###
### Calling Citrix Cloud Services Platform
### CwsAuth Authentication
$headers = @{
  Authorization = "CwsAuth Bearer=$($token.access_token)"
}

$response = Invoke-WebRequest $resourceLocUrl -Headers $headers
$response | ConvertFrom-Json | ConvertTo-Json -Depth 10


### --- list of services and the customer’s entitlement to use each one.
$response = Invoke-WebRequest "https://core.citrixworkspacesapi.net/$customerId/serviceStates" -Headers $headers
$serviceStates = $response | ConvertFrom-Json
$serviceStates | ConvertTo-Json -Depth 10

 

### --- Secure XML Traffic on Cloud Connectors
# install a Certificaiton in pfx format.
#get the Thumbprint from SSL Certification.
#get teh CLASSES from regkey (HKEY_CLASSES_ROOT\Installer\Products\) of Citrix Broker Service"

netsh http add sslcert ipport=0.0.0.0:443
certhash=PASTE_CERT_HASH_HERE_FROM_NOTEPAD appid={PASTE_XD_GUID_HERE_BETWEEN_FROM_NOTEPAD}

###--- Slient install of CCC ---###

$CustomerID="from citrix.com"
$ClientId="from API"
$clientSecret= "from API"
$ResourceLocationId="from GUI, Resrouce Location"
C:\CWCConnector.exe /q /Customer:$CustomerID /ClientId:$ClientId /clientSecret:$clientSecret /ResourceLocationId:$ResourceLocationId /AcceptTermsOfService:true

$CustomerID ="0pntwmcx64rk"
Set-XDCredentials -CustomerId $CustomerID -SecureClientFile "C:\users\Administrator.WORKSPACELAB\Downloads\secureclient.csv" -ProfileType CloudApi -StoreAs "CloudAdmin"
Get-XDCredentials –ListProfiles 






#Declare dependent variables.
$users = "workspacelab.com\engineer1"
$CatalogName = "NYC-CAT-DesktopOS"
$MachineName = "workspacelab.com\NYC-WRK-001"




#Create Catalog
$brokerUsers = New-BrokerUser -Name $users
$catalog = New-BrokerCatalog -AllocationType Permanent -IsRemotePC $False -MachinesArePhysical $True -MinimumFunctionalLevel "L7_20" -Name $CatalogName -PersistUserChanges "onlocal" -ProvisioningType Manual -Scope @() -SessionSupport SingleSession 
#Declare the variables to be used for creating a Delivery group.
$users = "workspacelab.com\engineer1"
$DGName = "NYC-DG-DesktopOS"
$MachineName = "workspacelab\NYC-WRK-001"
$Catalog = Get-BrokerCatalog -Name "NYC-CAT-DesktopOS"
$BrokerMachine = Get-BrokerMachine -machinename $MachineName -Cataloguid $Catalog.uid
#Create a Delivery Group.
$dg=New-BrokerDesktopGroup -ColorDepth "TwentyFourBit" -DeliveryType "DesktopsOnly" -DesktopKind "Private" -InMaintenanceMode $False -IsRemotePC $False -MinimumFunctionalLevel "L7_9" -Name "$DGName" -OffPeakBufferSizePercent 10 -PeakBufferSizePercent 10 -PublishedName "$DGName" -Scope @() -SecureIcaRequired $False -SessionSupport "SingleSession" -ShutdownDesktopsAfterUse $False  
Add-BrokerMachine -DesktopGroup “$DGName” -MachineName $BrokerMachine.SID
Add-BrokerUser -Machine $BrokerMachine.sid -Name $users
#Create an access rule for incoming connections via StoreFront
New-BrokerAccessPolicyRule -AllowedConnections "NotViaAG" -AllowedProtocols @("HDX","RDP") -AllowedUsers "AnyAuthenticated" -AllowRestart $True -DesktopGroupUid $dg.Uid -Enabled $True -IncludedSmartAccessFilterEnabled $True -IncludedUserFilterEnabled $True -IncludedUsers @() -Name "DOS_Direct"
#Create an access rule for incoming connections via Citrix Gateway
New-BrokerAccessPolicyRule -AllowedConnections "ViaAG" -AllowedProtocols @("HDX","RDP") -AllowedUsers "AnyAuthenticated" -AllowRestart $True -DesktopGroupUid $dg.uid -Enabled $True -IncludedSmartAccessFilterEnabled $True -IncludedSmartAccessTags @() -IncludedUserFilterEnabled $True -IncludedUsers @() -Name"DOS_AG"
